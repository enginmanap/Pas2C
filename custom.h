#include <string.h>
#include <stdlib.h>

#define TO_INT_BUFFER_SIZE 20

struct VariableAttributes{
    int type;
    char* name;
    union{
        int un_int;
        char* un_str;
    }data;
};

typedef struct VariableAttributes VariableAttributes;

struct ParameterListNode{
    VariableAttributes var;
    struct ParameterListNode* next;
};

typedef struct ParameterListNode ParameterListNode;

static ParameterListNode parameterListHead = {0};

void addParameterToList(VariableAttributes attr){
    ParameterListNode* current = &parameterListHead;
    while(current->next)
        current = current->next;
    ParameterListNode* new_node = (ParameterListNode*) malloc(sizeof(ParameterListNode));
    new_node->var = attr;
    new_node->next = 0;
    current->next = new_node;
}

void cleanParameterList(){
    ParameterListNode* current = parameterListHead.next;
    ParameterListNode* backup;
    while(current){
        backup = current; 
        current = current->next;
        free(backup->var.data.un_str);
        free(backup->var.name);
        free(backup);
    }
}

void printParameterList(){
    ParameterListNode* current = parameterListHead.next;
    while(current){
        if(current->var.name == "str")
            fprintf(stderr,"PRINTLIST:\tParameter is str[%s]\n", current->var.data.un_str);
        else if(current->var.name == "int")
            fprintf(stderr,"PRINTLIST:\tParameter is int[%d]\n", current->var.data.un_int);
        else if(current->var.name == "var")
            fprintf(stderr,"PRINTLIST:\tParameter is variable[%s]\n", current->var.data.un_str);
        current = current->next;
    }
}


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
