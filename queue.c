#include "bootpack.h"

void init_queue8(queue8_t* q, unsigned char* buf, int cap)
{
  q->buf = buf;
  q->cap = cap;
  q->size = 0;
  q->head = 0;
  q->last = 0;
}

void queue8_push(queue8_t* q, unsigned char data)
{
  if(q->size == q->cap)
    return;
  if(q->last == q->cap)
    q->last = 0;

  q->buf[q->last] = data;
  q->last++;
  q->size++;
}

unsigned char queue8_pop(queue8_t* q)
{
  if(q->head == q->cap)
    q->head = 0;
  if(q->head == q->last)
    return 0;

  unsigned char data = q->buf[q->head];
  q->head++;
  q->size--;
  return data;
}

int queue8_size(queue8_t* q)
{
  return q->size;
}
