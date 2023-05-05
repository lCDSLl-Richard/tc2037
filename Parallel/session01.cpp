#include <iostream>
#include <pthread.h>

using namespace std;

const int THREADS = 4;

typedef struct
{
  int id, start, end;
} Block;

void *display(void *params)
{
  Block *block;
  block = (Block *)params;

  for (int i = block->start; i <= block->end; i++)
  {
    cout << i << " ";
  }

  cout << endl;
  cout << "Thread " << block->id << " has finished";
  pthread_exit(0);
}

int main()
{
  pthread_t tid[THREADS];
  Block blocks[THREADS];

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].id = i;
    blocks[i].start = i * 10;
    blocks[i].end = (i + 1) * 10;
    pthread_create(&tid[i], NULL, display, &blocks[i]);
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_join(tid[i], NULL);
  }

  cout << "Thread t1 has finished" << endl;

  return 0;
}