#include <iostream>
#include <iomanip>
#include <pthread.h>
#include "utils.h"

using namespace std;

const int SIZE = 100000000;
const int THREADS = 8;

typedef struct
{
  int start, end;
  int *arr;
  double result;
} Block;

double sum(int *arr, int size)
{
  double acum = 0;

  for (int i = 0; i < size; i++)
  {
    acum += arr[i];
  }

  return acum;
}

void *sum_block(void *params)
{
  Block *block;
  block = (Block *)params;
  double acum = 0;

  for (int i = block->start; i < block->end; i++)
  {
    acum += block->arr[i];
  }

  block->result = acum;

  pthread_exit(0);
}

int main(int argc, char *argv[])
{
  int *arr;

  arr = new int[SIZE];
  fill_array(arr, SIZE);

  double time = 0, result = 0;

  for (int i = 0; i < N; i++)
  {
    start_timer();
    result = sum(arr, SIZE);
    time += stop_timer();
  }
  cout << "result = " << fixed << setprecision(0) << result << endl;
  cout << "Average time: " << fixed << setprecision(2) << time / N << " ms" << endl;

  pthread_t tid[THREADS];
  Block blocks[THREADS];

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].start = i * SIZE / THREADS;
    blocks[i].end = (i != (THREADS - 1)) ? (i + 1) * SIZE / THREADS : SIZE;
    blocks[i].arr = arr;
  }

  time = 0;
  result = 0;
  for (int i = 0; i < N; i++)
  {
    start_timer();
    for (int j = 0; j < THREADS; j++)
    {
      pthread_create(&tid[j], NULL, sum_block, &blocks[j]);
    }
    for (int j = 0; j < THREADS; j++)
    {
      pthread_join(tid[j], NULL);
      result += blocks[j].result;
    }
    time += stop_timer();
  }
  cout << "result = " << fixed << setprecision(0) << result << endl;
  cout << "Average time: " << fixed << setprecision(2) << time / N << " ms" << endl;
}