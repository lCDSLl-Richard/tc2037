#include <iostream>
#include <pthread.h>
#include "utils.h"

using namespace std;

const int SIZE = 100000000;
const int THREADS = 8;

typedef struct
{
  int start, end;
  int *a, *b, *c;
} Block;

void add_vectors(int *a, int *b, int *c)
{
  for (int i = 0; i < SIZE; i++)
  {
    c[i] = a[i] + b[i];
  }
}

void *add_vectors_thread(void *params)
{
  Block *block;

  block = (Block *)params;
  for (int i = 0; i < block->end; i++)
  {
    block->c[i] = block->a[i] + block->b[i];
  }

  pthread_exit(0);
}

int main()
{
  int *a, *b, *c;
  double time;

  a = new int[SIZE];
  fill_array(a, SIZE);

  b = new int[SIZE];
  fill_array(b, SIZE);

  c = new int[SIZE];

  for (int i = 0; i < N; i++)
  {
    start_timer();
    add_vectors(a, b, c);
    time += stop_timer();
  }

  display_array("Result ", c);
  cout << "Time: " << time / N << " ms" << endl;

  pthread_t tid[THREADS];
  Block blocks[THREADS];

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].start = i * SIZE / THREADS;
    blocks[i].end = i != THREADS - 1 ? (i + 1) * SIZE / THREADS : SIZE;
    blocks[i].a = a;
    blocks[i].b = b;
    blocks[i].c = c;
  }

  time = 0;

  for (int i = 0; i < N; i++)
  {
    start_timer();
    for (int j = 0; j < THREADS; j++)
    {
      pthread_create(&tid[j], NULL, add_vectors_thread, &blocks[j]);
    }
    for (int j = 0; j < THREADS; j++)
    {
      pthread_join(tid[j], NULL);
    }
    time += stop_timer();
  }
  display_array("Result ", c);
  cout << "Time: " << time / N << " ms" << endl;
}