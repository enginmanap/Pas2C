#include <stdio.h>
int main()
{
    const int const1=5;
    const int const2=7;
    int variable_1;
    int variable2, variable3, variable15;
    printf("Hello world!\n");
    printf("Please enter a number :");
    scanf("%d", &variable_1);
    printf("the nu\\mber is :%d\n", variable_1);
    printf("Enter two more:\n");
    scanf("%d %d", &variable2, &variable3);
    fflush(stdin);
    {
        variable15=variable2/variable3;
    }
    printf("%d + %d / %d\n", variable_1, variable2, variable3);
    printf("is ");
    printf("%d\n", variable_1+variable15);
}
