#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char * argv[])
{

    if(argc == 1){
        printf(1, "Enter at least one integer\n");
        exit();
    }

    struct intstruct *allnumbers = malloc(sizeof(struct intstruct));
    allnumbers->sz = argc-1;
    int i;

    for(i=1;i<argc;i++){
        allnumbers->nums[i-1] = atoi(argv[i]);
    }
    printf(1, "Sum of %d numbers = %d\n", argc-1, add(allnumbers));
    exit();

}