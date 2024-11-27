#include <stdio.h>
#include <string.h>

int main()
{
    char buf[21] = "ASASAASASSASSAASASAS\0";
    char str[2] = "AS";
    int count = 0;
    for(int i = 0; i < strlen(buf) - 1;i++){
        if(buf[i] == str[0]){
            if(buf[i+1] == str[1]){
                count++;
            }
        }
    }
    printf("The number of 'AS' is: %d\n",count);
    return 0;
}