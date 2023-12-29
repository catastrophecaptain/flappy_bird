#include <stdio.h>
int main()
{
    while(1)
    {
        char str[4];
        int num;
        scanf("%s", str);
        scanf("%d", &num);
        printf("%s %d\n", str, num*95600/124);
    }
}
