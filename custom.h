#include <string.h>
#include <stdlib.h>

#define TO_INT_BUFFER_SIZE 20

char* strconcat(char* str1, char* str2) {
    int str1_len = strlen(str1);
    int str2_len = strlen(str2);
    char* new_str = (char*)malloc((str1_len + str2_len + 1)* sizeof(char));
    strcpy(new_str, str1);
    strcat(new_str, str2);
    return new_str;
}

char* intToStr(int number) {
    char* buffer = (char*)malloc((TO_INT_BUFFER_SIZE)* sizeof(char));
    sprintf(buffer, "%d", number);
    return buffer;
}

char* findCVariant(char* str1) {
    if (!strcmp("writeln",str1))
	return "printf";
    else 
	if (!strcmp("readln",str1))
            return "scanf";
	else
	    return str1;
    
}

void generateHeader() {
    printf("#include <stdio.h>\n");
    return;
}
