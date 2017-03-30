#include <stdio.h>
#include "bootpack.h"

extern queue8_t keybuf;
extern queue8_t mousebuf;

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

          boxfill8(binfo->vram, binfo->scrnx, COL8_008484, mx, my, mx+16, my+16);
          mx += mousestate.x;
          my += mousestate.y;
          if(mx < 0)
            mx = 0;
          if(my < 0)
            my = 0;
          if(mx > binfo->scrnx-16)
            mx = binfo->scrnx-16;
          if(my > binfo->scrny-16)
            my = binfo->scrny-16;
          putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mouse, 16);
        }
      }
    }
  }
}

