#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char * argv[])
{
    
    if(argc < 2)
    {
        printf(1,"Enter swapping algorithm:\n0:FIFO\n1:Aging\n");
        exit();
    }

    int sw = atoi(argv[1]);

    if(sw)
    {
        aging();
    }
    
    
    int *a;
    int n = 20 * 4096 / sizeof(int);


    a = malloc(n * sizeof(int));

    
    printf(1, "Press ^P\n");
    
    fork();

    sleep(200);

    for(int i=0;i<n;i++)
    {
        a[i]=i;
    }
    
    sbrk(5*4096);

    

    int cnt = 0;
    for(int i=0;i<n;i++)
    {
        if(a[i] != i)
        {
            cnt++;
        }
    }

   
    
    if(cnt == 0)
    {
        printf(1, "all numbers match\n");
    }
    else {
        printf(1, "%d numbers dont match\n", cnt);
    
    }

    wait();
    
    exit();



}   
