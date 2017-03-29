#include <stdio.h>
#include "bootpack.h"

extern queue8_t keybuf;
extern queue8_t mousebuf;

void init_keyboard(void);
void enable_mouse(void);

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

  enable_mouse();
  
  while(1) {
    io_cli();
    if(queue8_size(&keybuf) + queue8_size(&mousebuf) == 0) {
      io_stihlt();
    } else {
      if(queue8_size(&keybuf) != 0) {
        data = queue8_pop(&keybuf);
        io_sti();

        sprintf(s, "K %02X", data, queue8_size(&keybuf));
        boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 0, 60, 30);
        putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
      } else if(queue8_size(&mousebuf) != 0) {
        data = queue8_pop(&mousebuf);
        io_sti();

        sprintf(s, "M %02X", data);
        boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 0, 60, 30);
        putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
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
