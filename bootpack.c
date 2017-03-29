#include <stdio.h>
#include "bootpack.h"

extern queue8_t keybuf;
extern queue8_t mousebuf;

typedef struct {
  int x, y, phase, btn;
  int data[3];
} mousestate_t;

void init_keyboard(void);
void enable_mouse(void);
void init_mousestate(mousestate_t* ms);
int decode_mousestate(mousestate_t* ms, int data);

void HariMain(void)
{
  struct BOOTINFO* binfo = (struct BOOTINFO*) 0xff0;
  char s[40];
  char mouse[16*16];
  int mx, my;

  init_gdtidt();
  init_pic();
  io_sti(); // IDT/PICの初期化が終わったのでCPU割り込み禁止を解除

  io_out8(PIC0_IMR, 0xf9); // PIC1とキーボードを許可
  io_out8(PIC1_IMR, 0xef); // マウスを許可

  init_keyboard();

  init_palette();
  init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

  mx = (binfo->scrnx - 16) / 2;
  my = (binfo->scrny - 28 - 16) / 2;
  init_mouse_cursor8(mouse, COL8_008484);
  putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mouse, 16);
  sprintf(s, "(%d, %d)", mx, my);
  putfont8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, s);

  init_keybuf();
  init_mousebuf();

  int data;
  mousestate_t mousestate;
  init_mousestate(&mousestate);

  enable_mouse();
  
  while(1) {
    io_cli();
    if(queue8_size(&keybuf) + queue8_size(&mousebuf) == 0) {
      io_stihlt();
    } else {
      if(queue8_size(&keybuf) != 0) {
        data = queue8_pop(&keybuf);
        io_sti();

        sprintf(s, "K %02X", data);
        boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 0, 60, 30);
        putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
      } else if(queue8_size(&mousebuf) != 0) {
        data = queue8_pop(&mousebuf);
        io_sti();

        if(decode_mousestate(&mousestate, data) != 0) {
          sprintf(s, "%d %d", mousestate.x, mousestate.y);
          boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 25, 100, 41);
          putfont8_asc(binfo->vram, binfo->scrnx, 0, 25, COL8_FFFFFF, s);
        }
      }
    }
  }
}


#define PORT_KEYDAT 0x0060
#define PORT_KEYSTA 0x0064
#define PORT_KEYCMD 0x0064
#define KEYSTA_SEND_NOTREADY 0x02
#define KEYCMD_WRITE_MODE    0x60
#define KBC_MODE             0x47

void wait_KBC_sendready(void)
{
  for(;;) {
    if((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
      break;
    }
  }
}

// キーボードコントローラ初期化
void init_keyboard(void)
{
  wait_KBC_sendready();
  io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
  wait_KBC_sendready();
  io_out8(PORT_KEYDAT, KBC_MODE);
}

#define KEYCMD_SENDTO_MOUSE 0xd4
#define MOUSECMD_ENABLE 0xf4

void enable_mouse(void)
{
  wait_KBC_sendready();
  io_out8(PORT_KEYCMD, KEYCMD_SENDTO_MOUSE);
  wait_KBC_sendready();
  io_out8(PORT_KEYDAT, MOUSECMD_ENABLE);
}

void init_mousestate(mousestate_t* ms)
{
  ms->x = 0;
  ms->y = 0;
  ms->phase = 0;
  ms->btn = 0;
  ms->data[0] = 0;
  ms->data[1] = 0;
  ms->data[2] = 0;
}

// return: 0(未デコード) 1(デコード済み)
int decode_mousestate(mousestate_t* ms, int data)
{
  if(ms->phase == 0) {
    if(data == 0xfa)
      ms->phase++;
    return 0;
  }

  if(ms->phase == 1) {
    if((data & 0xc8) == 0x08) { // phase1を待つ(データロス対策)
      ms->data[0] = data;
      ms->phase++;
    }
    return 0;
  }
  
  if(ms->phase == 2) {
    ms->data[1] = data;
    ms->phase++;
    return 0;
  }
  
  if(ms->phase == 3) {
    ms->data[2] = data;
    ms->phase = 1;

    ms->x = ms->data[1];
    ms->y = ms->data[2];
    ms->btn = ms->data[0] & 0x07;
    // ??
    if((ms->data[0] & 0x10) != 0)
      ms->x |= 0xffffff00;
    if((ms->data[0] & 0x20) != 0)
      ms->y |= 0xffffff00;

    ms->y = -ms->y;
    return 1;
  }
  return 0;
}
