#include "bootpack.h"
#include <stdio.h>

// PIC初期化
void init_pic(void)
{
  // 全ての割り込みを受け付けない
  io_out8(PIC0_IMR, 0xff);
  io_out8(PIC1_IMR, 0xff);

  io_out8(PIC0_ICW1, 0x11); // エッジトリガモード
  io_out8(PIC0_ICW2, 0x20); // IRQ0-7はINT20-27で受ける
  io_out8(PIC0_ICW3, 1 << 2); // PIC1はIRQ2にて接続
  io_out8(PIC0_ICW4, 0x01); // ノンバッファモード

  io_out8(PIC1_ICW1, 0x11); // エッジトリガモード
  io_out8(PIC1_ICW2, 0x28); // IRQ8-15はINT28-2fで受ける
  io_out8(PIC1_ICW3, 2); // PIC1はIRQ2にて接続
  io_out8(PIC1_ICW4, 0x01); // ノンバッファモード

  io_out8(PIC0_IMR, 0xfb); // 11111011 PIC1以外は全て禁止
  io_out8(PIC1_IMR, 0xff); // 全ての割り込みを受け付けない
}

#define PORT_KEYDAT 0x0060

// PS/2キーボードからの割り込み
void inthandler21(int *esp)
{
  struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;

  unsigned char data;
  char s[4];
  io_out8(PIC0_OCW2, 0x61); // IRQ-01受付完了をPICに通知
  data = io_in8(PORT_KEYDAT);

  sprintf(s, "%02X", data);
  boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 16, 15, 31);
  putfont8_asc(binfo->vram, binfo->scrnx, 0, 16, COL8_FFFFFF, s);
}

// PS/2マウスからの割り込み
void inthandler2c(int *esp)
{
  struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
  boxfill8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32*8-1, 15);
  putfont8_asc(binfo->vram, binfo->scrnx, 0, 0,
               COL8_FFFFFF, "INT 2C(IRQ-12) : PS/2 mouse");
  for(;;) {
    io_hlt();
  }
}

// PIC0からの不完全割り込み対策
void inthandler27(int *esp)
{
  io_out8(PIC0_OCW2, 0x67); // IRQ-07受付完了をPICに通知
  return;

}
