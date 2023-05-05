#include <iostream>
#include <pthread.h>
#include <unistd.h>
#include <sstream>

using namespace std;

const int CARS = 100;

typedef enum
{
  NORTH,
  SOUTH
} Direction;

typedef struct
{
  Direction dir;
  int id;
} carInfo;

pthread_mutex_t enterBridge;
pthread_cond_t spaceAvailable, emptyBridge;

int currCarsInBridge = 0;
int currCarsWaiting[2] = {0, 0};
Direction currentDir;

void arriveBridge(Direction dir, int id)
{
  stringstream ss;
  pthread_mutex_lock(&enterBridge);
  ss << "Car " << id << " attempting to cross bridge, heading: " << dir << endl;
  cout << ss.str();
  if (currCarsInBridge == 0)
  {
    currentDir = dir;
    cout << "Car " << id << " has entered first to the bridge, heading: " << dir << endl;
  }
  else if (currCarsInBridge < 3 && dir == currentDir)
  {
    cout << "Car " << id << " has entered the bridge, heading: " << dir << endl;
  }
  else if (dir == currentDir)
  {
    cout << "Car " << id << " is waiting to enter the bridge, heading: " << dir << endl;
    currCarsWaiting[dir]++;
    pthread_cond_wait(&spaceAvailable, &enterBridge);
    currCarsWaiting[dir]--;
  }
  else
  {
    cout << "Car " << id << " is waiting for the bridge to empty, heading: " << dir << endl;
    currCarsWaiting[dir]++;
    pthread_cond_wait(&emptyBridge, &enterBridge);
    currCarsWaiting[dir]--;
  }

  currCarsInBridge++;
  pthread_mutex_unlock(&enterBridge);
  return;
}

void crossBridge(Direction dir, int id)
{
  stringstream ss;
  ss << "Car " << id << " is crossing the bridge, heading: " << dir << endl;
  cout << ss.str();
  usleep(30000);
  return;
}

void exitBridge(Direction dir, int id)
{
  pthread_mutex_lock(&enterBridge);
  currCarsInBridge--;
  cout << "Car " << id << " has exited the bridge, heading: " << dir << endl;
  if (currCarsInBridge == 0 && currCarsWaiting[dir] == 0)
  {
    currentDir = (Direction)(1 - dir);
    cout << "Bridge is empty, heading: " << currentDir << endl;
    pthread_cond_broadcast(&emptyBridge);
  }
  else
  {
    pthread_cond_signal(&spaceAvailable);
  }
  pthread_mutex_unlock(&enterBridge);
  return;
}

void *car(void *params)
{
  carInfo *info = (carInfo *)params;
  arriveBridge(info->dir, info->id);
  crossBridge(info->dir, info->id);
  exitBridge(info->dir, info->id);
  pthread_exit(0);
}

int main()
{
  srand(time(NULL));
  pthread_t threads[CARS];
  carInfo cars[CARS];

  pthread_mutex_init(&enterBridge, NULL);
  pthread_cond_init(&spaceAvailable, NULL);
  pthread_cond_init(&emptyBridge, NULL);

  for (int i = 0; i < CARS; i++)
  {
    cars[i].id = i;
    cars[i].dir = (Direction)(rand() % 2);
    pthread_create(&threads[i], NULL, car, &cars[i]);
    usleep(10000);
  }

  for (int i = 0; i < CARS; i++)
  {
    pthread_join(threads[i], NULL);
  }

  pthread_mutex_destroy(&enterBridge);
  pthread_cond_destroy(&spaceAvailable);
  pthread_cond_destroy(&emptyBridge);

  return 0;
}