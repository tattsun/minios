#include <stdio.h>
#include "bootpack.h"

void HariMain(void)
{
  struct BOOTINFO* binfo = (struct BOOTINFO*) 0xff0;
  char s[40];
  char mouse[16*16];
  int mx, my;

  init_gdtidt();
  init_pic();
  io_sti(); // IDT/PICの初期化が終わったのでCPU割り込み禁止を解除

  init_palette();
  init_screen(binfo->vram, binfo->scrnx, binfo->scrny);

  mx = (binfo->scrnx - 16) / 2;
  my = (binfo->scrny - 28 - 16) / 2;
  init_mouse_cursor8(mouse, COL8_008484);
  putblock8_8(binfo->vram, binfo->scrnx, 16, 16, mx, my, mouse, 16);
  sprintf(s, "(%d, %d)", mx, my);
  putfont8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, s);

  io_out8(PIC0_IMR, 0xf9); // PIC1とキーボードを許可(11111001)
  io_out8(PIC1_IMR, 0xef); // マウスを許可(11101111)

  while(1)
    io_hlt();
}
