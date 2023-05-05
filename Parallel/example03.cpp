#include <iostream>
#include <pthread.h>
#include "utils.h"

using namespace std;

const int SIZE = 10000;
const int THREADS = 8;

typedef struct
{
  int start, end, size;
  int *arr, *sorted;
} Block;

void enumaration_sort(int *arr, int *sorted, int size)
{
  int count;
  for (int i = 0; i < size; i++)
  {
    count = 0;
    for (int j = 0; j < size; j++)
    {
      if (arr[j] < arr[i])
      {
        count++;
      }
      else if (arr[j] == arr[i] && j < i)
      {
        count++;
      }
    }
    sorted[count] = arr[i];
  }
}

void *enumeration_sort_thread(void *params)
{
  Block *block = (Block *)params;
  int count;

  for (int i = block->start; i < block->end; i++)
  {
    count = 0;
    for (int j = 0; j < block->size; j++)
    {
      if (block->arr[j] < block->arr[i])
      {
        count++;
      }
      else if (block->arr[j] == block->arr[i] && j < i)
      {
        count++;
      }
    }
    block->sorted[count] = block->arr[i];
  }
}

int main()
{
  int *arr, *sorted;
  arr = new int[SIZE];
  sorted = new int[SIZE];

  double time = 0;

  random_array(arr, SIZE);

  for (int i = 0; i < N; i++)
  {
    start_timer();
    enumaration_sort(arr, sorted, SIZE);
    time += stop_timer();
  }

  display_array("Sorted: ", sorted);
  cout << "Time: " << time / N << " ms" << endl;

  pthread_t tid[THREADS];
  Block blocks[THREADS];

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].arr = arr;
    blocks[i].sorted = sorted;
    blocks[i].size = SIZE;
    blocks[i].start = i * SIZE / THREADS;
    blocks[i].end = i != THREADS - 1 ? (i + 1) * SIZE / THREADS : SIZE;
  }

  time = 0;

  for (int j = 0; j < N; j++)
  {
    start_timer();
    for (int i = 0; i < THREADS; i++)
    {
      pthread_create(&tid[i], NULL, enumeration_sort_thread, &blocks[i]);
    }

    for (int i = 0; i < THREADS; i++)
    {
      pthread_join(tid[i], NULL);
    }
    time += stop_timer();
  }

  display_array("Sorted: ", sorted);
  cout << "Time: " << time / N << " ms" << endl;
}