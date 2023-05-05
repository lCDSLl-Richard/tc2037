#include <iostream>
#include <time.h>
#include <unistd.h>

using namespace std;

int slices = 8;
const int times = 2;
const int STUDENTS = 8;

pthread_mutex_t grabSlice, orderPizza;
pthread_cond_t pizzaReady, pizzaReceived;

void *student(void *params)
{
  while (true)
  {
    pthread_mutex_lock(&grabSlice);
    if (slices > 0)
    {
      cout << "grabbing slice..." << endl;
      slices--;
    }
    else
    {
      cout << "waiting for pizza..." << endl;
      pthread_cond_wait(&pizzaReady, &orderPizza);
      cout << "pizza arrived..." << endl;
      slices--;
    }
    cout << "eating slice..." << endl;
    pthread_mutex_unlock(&grabSlice);
    pthread_cond_signal(&pizzaReceived);
    sleep(rand() % 3);
  }
  pthread_exit(0);
}

void *pizzeria(void *params)
{
  while (true)
  {
    pthread_mutex_lock(&orderPizza);
    cout << "order received..." << endl;
    slices = 8;
    sleep(rand() % 3);
    cout << "pizza ready..." << endl;
    pthread_cond_signal(&pizzaReady);
    pthread_cond_wait(&pizzaReceived, &orderPizza);
    pthread_mutex_unlock(&orderPizza);
  }
  pthread_exit(0);
}

int main()
{
  pthread_t students[STUDENTS];
  pthread_t pizzerias;

  pthread_mutex_init(&grabSlice, NULL);
  pthread_mutex_init(&orderPizza, NULL);
  pthread_cond_init(&pizzaReady, NULL);
  pthread_cond_init(&pizzaReceived, NULL);

  pthread_mutex_lock(&orderPizza);

  srand(time(NULL));

  for (int i = 0; i < STUDENTS; i++)
  {
    pthread_create(&students[i], NULL, student, NULL);
  }
  pthread_create(&pizzerias, NULL, pizzeria, NULL);

  for (int i = 0; i < STUDENTS; i++)
  {
    pthread_join(students[i], NULL);
  }
  pthread_join(pizzerias, NULL);

  return 0;
}