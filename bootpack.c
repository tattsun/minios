#define COL8_BLACK       {0x00, 0x00, 0x00}
#define COL8_RED         {0xff, 0x00, 0x00}
#define COL8_GREEN       {0x00, 0xff, 0x00}
#define COL8_YELLOW      {0xff, 0xff, 0x00}
#define COL8_BLUE        {0x00, 0x00, 0xff}
#define COL8_PURPLE      {0xff, 0x00, 0xff}
#define COL8_SKYBLUE     {0x00, 0xff, 0xff}
#define COL8_WHITE       {0xff, 0xff, 0xff}
#define COL8_GRAY        {0xc6, 0xc6, 0xc6}
#define COL8_DARKRED     {0x84, 0x00, 0x00}
#define COL8_DARKGREEN   {0x00, 0x84, 0x00}
#define COL8_DARKYELLOW  {0x84, 0x84, 0x00}
#define COL8_DARKBLUE    {0x00, 0x00, 0x84}
#define COL8_DARKPURPLE  {0x84, 0x00, 0x84}
#define COL8_DARKSKYBLUE {0x00, 0x84, 0x84}
#define COL8_DARKGRAY    {0x84, 0x84, 0x84}


void io_hlt(void);
void io_cli(void);
void io_out8(int port, int data);
int io_load_eflags(void);
void io_store_eflags(int eflags);


typedef struct {
  unsigned char r;
  unsigned char g;
  unsigned char b;
} rgb_t;
void init_palette(void);
void set_palette(int size, rgb_t* rgb);

void HariMain(void)
{
  int i;
  char* p = (char*)0xa0000;

  init_palette();

  // VRAMは0xa0000 ~ 0xaffffまで(8bit単位)
  for(i=0; i<0xffff; i++) {
    p[i] = i & 0xf;
  }

  while(1)
    io_hlt();
}


void init_palette(void)
{
  static rgb_t rgb[16] = {
    COL8_BLACK,
    COL8_RED,
    COL8_GREEN,
    COL8_YELLOW,
    COL8_BLUE,
    COL8_PURPLE,
    COL8_SKYBLUE,
    COL8_WHITE,
    COL8_GRAY,
    COL8_DARKRED,
    COL8_DARKGREEN,
    COL8_DARKYELLOW,
    COL8_DARKBLUE,
    COL8_DARKPURPLE,
    COL8_DARKSKYBLUE,
    COL8_DARKGRAY,
  };
  set_palette(16, rgb);
}

void set_palette(int size, rgb_t* rgb)
{
  int i, eflags;
  eflags = io_load_eflags();
  io_cli();

  io_out8(0x03c8, 0);
  for(i=0; i<size; i++) {
    io_out8(0x03c9, rgb->r / 4);
    io_out8(0x03c9, rgb->g / 4);
    io_out8(0x03c9, rgb->b / 4);
    rgb++;
  }

  io_store_eflags(eflags);
}
