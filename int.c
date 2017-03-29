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

queue8_t keybuf;
unsigned char keybuf_buf[32];

queue8_t mousebuf;
unsigned char mousebuf_buf[128];

void init_keybuf(void)
{
  init_queue8(&keybuf, keybuf_buf, 32);
}


// PS/2キーボードからの割り込み
void inthandler21(int *esp)
{
  unsigned char data;
  io_out8(PIC0_OCW2, 0x61); // IRQ-01受付完了をPICに通知
  data = io_in8(PORT_KEYDAT);

  queue8_push(&keybuf, data);
}

void init_mousebuf(void)
{
  init_queue8(&mousebuf, mousebuf_buf, 128);
}

// PS/2マウスからの割り込み
void inthandler2c(int *esp)
{
  unsigned char data;
  io_out8(PIC1_OCW2, 0x64); // IRQ-12受付完了をPICに通知
  io_out8(PIC0_OCW2, 0x62); // IRQ-02受付完了をPICに通知
  data = io_in8(PORT_KEYDAT);

  queue8_push(&mousebuf, data);
}

// PIC0からの不完全割り込み対策
void inthandler27(int *esp)
{
  io_out8(PIC0_OCW2, 0x67); // IRQ-07受付完了をPICに通知
  return;

}
