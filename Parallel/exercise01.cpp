#include <iostream>
#include <pthread.h>
#include <iomanip>
#include "utils.h"

const int PRECISION = 1000000000;
const int THREADS = 8;

using namespace std;

typedef struct
{
  int start, end;
  double sum;
} Block;

void *leibniz_pi_thread(void *params)
{
  double localSum = 0.0;
  Block *block = (Block *)params;
  for (int i = block->start; i < block->end; i++)
  {
    if (i % 2 == 0)
    {
      localSum += 1.0 / (2 * i + 1);
    }
    else
    {
      localSum -= 1.0 / (2 * i + 1);
    }
  }
  block->sum = localSum;
}

double leibniz_pi()
{
  int sign = 1;
  long double pi = 0.0;
  for (int i = 0; i < PRECISION; i++)
  {
    pi += sign / (2.0 * i + 1.0);
    sign *= -1;
  }
  return 4 * pi;
}

int main()
{
  start_timer();
  double pi = leibniz_pi();
  double time = stop_timer();
  cout << "pi = " << setprecision(20) << pi << endl;
  cout << "Time: " << time << " ms" << endl;

  pthread_t threads[THREADS];
  Block blocks[THREADS];
  double sum = 0.0;

  start_timer();

  for (int i = 0; i < THREADS; i++)
  {
    blocks[i].start = i * (PRECISION / THREADS);
    blocks[i].end = i != THREADS - 1 ? (i + 1) * (PRECISION / THREADS) : PRECISION;
    blocks[i].sum = 0.0;
    pthread_create(&threads[i], NULL, leibniz_pi_thread, &blocks[i]);
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_join(threads[i], NULL);
    sum += blocks[i].sum;
  }
  time = stop_timer();
  cout << "pi = " << fixed << setprecision(20) << 4 * sum << endl;
  cout << "Time: " << fixed << setprecision(2) << time << " ms" << endl;

  return 0;
}