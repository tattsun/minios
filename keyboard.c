#include "bootpack.h"

// キーボードコントローラ初期化
void init_keyboard(void)
{
  wait_KBC_sendready();
  io_out8(PORT_KEYCMD, KEYCMD_WRITE_MODE);
  wait_KBC_sendready();
  io_out8(PORT_KEYDAT, KBC_MODE);
}

void wait_KBC_sendready(void)
{
  for(;;) {
    if((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
      break;
    }
  }
}
