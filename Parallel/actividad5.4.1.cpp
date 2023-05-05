#include <iostream>
#include <pthread.h>
#include <time.h>
#include "utils.h"

using namespace std;

const int THREADS = 8;
const int ITERATIONS = 10000000;
pthread_mutex_t sumLock;

int insideCount = 0;

typedef struct
{
  int iterations, id;
} Block;

void *monteCarloThread(void *params)
{
  Block *block = (Block *)params;
  int internalCount = 0;

  for (int i = 0; i < block->iterations; i++)
  {
    double x = ((double)rand() / (RAND_MAX));
    double y = ((double)rand() / (RAND_MAX));

    if (x * x + y * y <= 1)
    {
      internalCount++;
    }
  }

  pthread_mutex_lock(&sumLock);
  insideCount += internalCount;
  pthread_mutex_unlock(&sumLock);
  pthread_exit(NULL);
}

double monteCarlo(int iterations)
{
  int inside = 0;

  for (int i = 0; i < iterations; i++)
  {
    double x = ((double)rand() / (RAND_MAX));
    double y = ((double)rand() / (RAND_MAX));

    if (x * x + y * y <= 1)
    {
      inside++;
    }
  }
  return inside / (double)iterations;
}

int main()
{
  srand(time(NULL));
  start_timer();
  cout << "calculating one thread" << endl;
  double pi = 4 * monteCarlo(ITERATIONS);
  double time = stop_timer();
  cout << "pi: " << pi << ". Time: " << time << " ms " << endl;

  pthread_t threads[THREADS];
  Block blocks[THREADS];
  pthread_mutex_init(&sumLock, NULL);

  start_timer();

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].iterations = i != THREADS - 1 ? ITERATIONS / THREADS : ITERATIONS - (ITERATIONS / THREADS) * (THREADS - 1);
    blocks[i].id = i;
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_create(&threads[i], NULL, monteCarloThread, &blocks[i]);
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_join(threads[i], NULL);
  }

  pi = 4.0 * insideCount / (double)ITERATIONS;
  time = stop_timer();
  cout << "pi: " << pi << ". Time: " << time << " ms " << endl;

  return 0;
}