#include <iostream>
#include <cmath>
#include <pthread.h>
#include "utils.h"

using namespace std;

typedef unsigned long int ulint;

#define MAX 5e6
#define THREADS 12

typedef struct
{
  ulint *sum;
  int start, end;
} Params;

bool isPrime(int n)
{
  if (n < 2)
    return false;

  for (int i = 2; i <= sqrt(n); i++)
  {
    if (n % i == 0)
      return false;
  }

  return true;
}

ulint primeSum(int n)
{
  ulint sum = 0;

  for (int i = 2; i < n; i++)
  {
    if (isPrime(i))
      sum += i;
  }

  return sum;
}

void *primeSumThread(void *arg)
{
  Params *params = (Params *)arg;

  for (int i = params->start; i < params->end; i++)
  {
    if (isPrime(i))
      *(params->sum) += i;
  }

  pthread_exit(0);
}

int main()
{

  start_timer();
  const ulint result = primeSum(MAX);
  const double oneThreadTime = stop_timer();
  cout << "Time: " << oneThreadTime << " ms. Result: " << result << endl;

  pthread_t threads[THREADS];
  Params params[THREADS];
  ulint sum = 0;

  start_timer();
  for (int i = 0; i < THREADS; i++)
  {
    params[i].sum = new ulint;
    params[i].start = i * (MAX / THREADS);
    params[i].end = i != THREADS - 1 ? (i + 1) * (MAX / THREADS) : MAX;
    pthread_create(&threads[i], NULL, primeSumThread, (void *)&params[i]);
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_join(threads[i], NULL);
  }

  for (int i = 0; i < THREADS; i++)
  {
    sum += *(params[i].sum);
  }

  const double multiThreadTime = stop_timer();
  cout << "Time: " << multiThreadTime << " ms. Result: " << sum << endl;
  cout << "Speed up using " << THREADS << " threads: " << oneThreadTime / multiThreadTime << endl;
}