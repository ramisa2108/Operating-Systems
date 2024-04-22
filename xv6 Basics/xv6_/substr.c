#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char * argv[])
{
    if(argc == 1){
        printf(1, "substr function needs a string parameter.\n");
        exit();
    }
    else if(argc > 4){
        printf(1, "too many arguments\n");
        exit();
    }

    char *s = argv[1];
    int start = 0, len;
    
    if(argc >= 3)
        start = atoi(argv[2]);
    
    if(argc == 4)
        len = atoi(argv[3]);
    else
        len = strlen(s) - start;


    printf(1, "Substring of length %d starting from %d of %s: %s\n", len, start, s, substr(s, start, len));
    exit();
}