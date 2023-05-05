#include <iostream>
#include <iomanip>
#include <pthread.h>
#include <semaphore.h>
#include <time.h>
#include <chrono>
#include <random>
#include <unistd.h>
#include <sstream>

#define N_CARS 30
#define MAX_CARS 3
#define CROSS_TIME 0.3
#define ARRIVE_TIME 0.1

sem_t bridge;
pthread_cond_t change_dir;
pthread_mutex_t dir_mutex;

std::string direction = "";

int lRand(int min, int max)
{
    return rand() % (max - min + 1) + min;
}

struct Car
{
    std::string direction;
    int id;
};

void arriveBridge(Car car)
{
    std::stringstream ss;
    ss << "Car " << car.id << " from " << car.direction << " arrived" << std::endl;
    std::cout << ss.str();

    pthread_mutex_lock(&dir_mutex);
    while (true)
    {
        if (direction == "" || direction == car.direction)
        {
            direction = car.direction;
            break;
        }
        pthread_cond_wait(&change_dir, &dir_mutex);
    }
    pthread_mutex_unlock(&dir_mutex);

    sem_wait(&bridge);
}

void crossBridge(Car car)
{
    // TODO
    std::stringstream ss;
    ss << "Car " << car.id << " from " << car.direction << " is crossing" << std::endl;
    std::cout << ss.str();
    usleep(CROSS_TIME * 1000000);
}

void exitBridge(Car car)
{
    // TODO
    std::stringstream ss;
    ss << "Car " << car.id << " from " << car.direction << " exited" << std::endl;
    std::cout << ss.str();
    sem_post(&bridge);

    pthread_mutex_lock(&dir_mutex);
    int value;
    sem_getvalue(&bridge, &value);
    if (value == MAX_CARS)
    {
        direction = "";
        std::cout << "\e[41mDirection changed\e[0m" << std::endl;
        pthread_cond_broadcast(&change_dir);
    }
    pthread_mutex_unlock(&dir_mutex);
}

void *oneCar(void *params)
{
    Car car = *((Car *)params);
    arriveBridge(car);
    crossBridge(car);
    exitBridge(car);

    pthread_exit(0);
}

int main()
{
    sem_init(&bridge, 0, MAX_CARS);
    pthread_mutex_init(&dir_mutex, NULL);
    pthread_cond_init(&change_dir, NULL);

    pthread_t cars_t[N_CARS];
    Car cars[N_CARS];

    std::mt19937 engine = std::mt19937();
    std::uniform_int_distribution<int> dist(0, 1);
    for (int i = 0; i < N_CARS; i++)
    {
        cars[i].id = i;
        cars[i].direction = dist(engine) == 0 ? "north" : "south";
        usleep(ARRIVE_TIME * 1000000);
        pthread_create(&cars_t[i], NULL, oneCar, (void *)&cars[i]);
    }

    for (int i = 0; i < N_CARS; i++)
    {
        pthread_join(cars_t[i], NULL);
    }

    return 0;
}