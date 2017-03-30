#include "bootpack.c"

void wait_KBC_sendready(void)
{
  for(;;) {
    if((io_in8(PORT_KEYSTA) & KEYSTA_SEND_NOTREADY) == 0) {
      break;
    }
  }
}
