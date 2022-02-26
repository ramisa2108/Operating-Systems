#include<cstdio>
#include<cstdlib>
#include<pthread.h>
#include<semaphore.h>
#include<cmath>
#include<climits>
#include<vector>
#include<unistd.h>
#include<chrono>
#include<random>
#include<cstring>

using namespace std;


const double LAMBDA = 1.0 / 3.0;
const int TOTAL_PASSENGERS = 40;
sem_t kiosks;

sem_t *belts;
pthread_mutex_t boardingGate;
pthread_mutex_t specialKiosk;
pthread_mutex_t VIPchannel;
pthread_mutex_t freeKioskMutex;

vector<int>freeKiosks;

pthread_cond_t waitingToGo[2];
int waitingPassengers[2];


int passengersOnVIPChannel = 0;
int currentDir = 0;

int M, N, P, w, x, y, z;

auto processStartTime = std::chrono::system_clock::now();


inline double calcTime()
{
    return std::chrono::duration<double> (chrono::system_clock::now() - processStartTime).count();
}

inline double calcNextArrivalTime()
{
    return -log(1.0 - 1.0 * random() / (1.0 + RAND_MAX)) / LAMBDA;
}

void selfCheckIn(char *pid)
{

    sem_wait(&kiosks);

    pthread_mutex_lock(&freeKioskMutex);
    int kioskNo = freeKiosks.back();
    freeKiosks.pop_back();
    pthread_mutex_unlock(&freeKioskMutex);

    printf("Passenger %s has started self-check in at kiosk %d at time %.0lf\n", pid, kioskNo, calcTime());

    sleep(w);

    printf("Passenger %s has finished check in at time %.0lf\n", pid, calcTime());

    pthread_mutex_lock(&freeKioskMutex);
    freeKiosks.push_back(kioskNo);
    pthread_mutex_unlock(&freeKioskMutex);

    sem_post(&kiosks);

    return ;

}

void enterVIPChannel(int dir)
{
    pthread_mutex_lock(&VIPchannel);

    while((dir != currentDir && passengersOnVIPChannel > 0) || (dir==1 && waitingPassengers[0] > 0))
    {
        waitingPassengers[dir]++;
        pthread_cond_wait(&waitingToGo[dir], &VIPchannel);
        waitingPassengers[dir]--;
    }

    passengersOnVIPChannel++;
    currentDir = dir;
    pthread_mutex_unlock(&VIPchannel);

    return ;
}

void exitVIPChannel(int dir)
{

    pthread_mutex_lock(&VIPchannel);
    passengersOnVIPChannel--;

    if(passengersOnVIPChannel == 0)
    {
        if(waitingPassengers[0] > 0)
        {
            pthread_cond_broadcast(&waitingToGo[0]);
        }
        else if(waitingPassengers[1] > 0)
        {
            pthread_cond_broadcast(&waitingToGo[1]);
        }
    }


    pthread_mutex_unlock(&VIPchannel);
    return ;

}

void goThroughVIPChannel(char *pid, int dir)
{
    sleep(1);
    printf("Passenger %s has started waiting for the VIP channel (dir = %d) at time %.0lf\n", pid, dir, calcTime());

    enterVIPChannel(dir);
    printf("Passenger %s has started moving on the VIP channel (dir = %d) at time %.0lf\n", pid, dir, calcTime());
    sleep(z);

    printf("Passenger %s has finished going through the VIP channel (dir = %d) at time %.0lf\n", pid, dir, calcTime());
    exitVIPChannel(dir);
    return ;

}
void securityCheckIn(char *pid)
{
    sleep(1);
    int beltNo = random() % N;

    printf("Passenger %s has started waiting for security check in belt %d from time %.0lf\n", pid, beltNo, calcTime());

    sem_wait(&belts[beltNo]);
    printf("Passenger %s has started the security check at time %.0lf\n", pid, calcTime());

    sleep(x);
    printf("Passenger %s has crossed the security check at time %.0lf\n", pid, calcTime());

    sem_post(&belts[beltNo]);

    return ;

}

bool boardingOnPlane(char *pid)
{
    sleep(1);
    printf("Passenger %s has started waiting to be boarded at time %.0lf\n", pid, calcTime());
    pthread_mutex_lock(&boardingGate);

    if(1.0 * random() / INT_MAX >= 0.7) // lose pass 30 percent of time
    {
        printf("Passenger %s has lost their boarding pass at time %.0lf\n", pid, calcTime());
        pthread_mutex_unlock(&boardingGate);
        return false;

    }
    else
    {
        printf("Passenger %s has started boarding the plane at time %.0lf\n", pid, calcTime());
        sleep(y);
        printf("Passenger %s has boarded the plane at time %.0lf\n", pid, calcTime());
        pthread_mutex_unlock(&boardingGate);
        return true;

    }

}

void specialKioskCheckIn(char *pid)
{
    sleep(1);
    printf("Passenger %s has started waiting at the special kiosk at time %.0lf\n", pid, calcTime());

    pthread_mutex_lock(&specialKiosk);
    printf("Passenger %s has started self-check in at the special kiosk at time %.0lf\n", pid, calcTime());
    sleep(w);

    printf("Passenger %s has finished check in at the special kiosk at time %.0lf\n", pid, calcTime());
    pthread_mutex_unlock(&specialKiosk);

    return ;

}

void *passengerFunction(void * passengerId)
{

    char pid[20];
    sprintf(pid, "%d", (int) ((size_t) passengerId));

    // assign VIP tag only 20 percent of the time
    bool isVip = (1.0 * random() / INT_MAX >= 0.8);
    if(isVip)
    {
        strcat(pid, " (VIP)");
    }
    // arrival
    printf("Passenger %s has arrived at the airport at time %.0lf\n", pid, calcTime());

    // self check in
    selfCheckIn(pid);

    // security check for non-VIP
    if(isVip)
    {
        goThroughVIPChannel(pid, 0);
    }
    else
    {
        securityCheckIn(pid);
    }


    //  get boarding pass
    while(!boardingOnPlane(pid))
    {
        // passenger has lost boarding pass
        goThroughVIPChannel(pid, 1);
        specialKioskCheckIn(pid);
        goThroughVIPChannel(pid, 0);

    }

    pthread_exit(NULL);

    return 0;

}


int main()
{


    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);

    srand(time(NULL));

    scanf("%d %d %d", &M, &N, &P);
    scanf("%d %d %d %d", &w, &x, &y, &z);


    pthread_mutex_init(&boardingGate, NULL);
    pthread_mutex_init(&specialKiosk, NULL);
    pthread_mutex_init(&freeKioskMutex, NULL);

    pthread_mutex_init(&VIPchannel, NULL);
    pthread_cond_init(&waitingToGo[0], NULL);
    pthread_cond_init(&waitingToGo[1], NULL);


    sem_init(&kiosks, 0, M);
    for(int i=0;i<M;i++){
        freeKiosks.push_back(i);
    }

    belts = new sem_t[N];
    for(int i=0;i<N;i++){
        sem_init(&belts[i], 0, P);
    }




    int passenger_id=1;

    while(passenger_id <= TOTAL_PASSENGERS)
    {
        double Next = calcNextArrivalTime();
        sleep(Next);
        pthread_t passenger;
        pthread_create(&passenger, NULL, passengerFunction, (void *)((size_t) (passenger_id++)));

    }

    for(int i=0;i<N;i++)
    {
        sem_destroy(&belts[i]);
    }

    freeKiosks.clear();
    sem_destroy(&kiosks);

    pthread_cond_destroy(&waitingToGo[1]);
    pthread_cond_destroy(&waitingToGo[0]);
    pthread_mutex_destroy(&VIPchannel);

    pthread_mutex_destroy(&freeKioskMutex);
    pthread_mutex_destroy(&specialKiosk);
    pthread_mutex_destroy(&boardingGate);


    pthread_exit(NULL);
    return 0;




}
