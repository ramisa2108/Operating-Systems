#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char * argv[])
{

    if(argc == 1)
    {
        printf(1, "Enter at least one number\n");
        exit();
    }

    printf(1, "Total arguments: %d\n", argc-1);
    int i;
    for(i=1;i<argc;i++){
        int x = atoi(argv[i]);
        int x1 = incr(x);
        printf(1, "(%d)++ = %d\n", x, x1);
    }
    exit();

}