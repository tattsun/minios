#include "bootpack.h"

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

