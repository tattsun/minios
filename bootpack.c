#include <stdio.h>
#include "bootpack.h"

void HariMain(void)
{
  struct BOOTINFO* binfo = (struct BOOTINFO*) 0xff0;
  char s[40];
  char mouse[16*16];

  init_gdtidt();
  init_pic();
  init_palette();
  init_screen(binfo->vram, binfo->scrnx, binfo->scrny);
  init_mouse_cursor8(mouse, COL8_008484);

  sprintf(s, "scrnx = %d", binfo->scrnx);
  putfont8_asc(binfo->vram, binfo->scrnx, 8, 8, COL8_FFFFFF, s);
  putblock8_8(binfo->vram, binfo->scrnx, 16, 16, 20, 20, mouse, 16);

  while(1)
    io_hlt();
}
