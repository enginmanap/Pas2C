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
        free(backup);
    }
    parameterListHead.next = 0;
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

char* cleanString(char* str){
    char current = str[0];
    int element = 0;
    int size = 0;
    while(current != '\0'){
        if(current == '\\')
            size++;
        size++;
        element++;
        current = str[element];
    }
    char* new_str = (char*)malloc((size + 1)* sizeof(char));
    element = 0;
    current = str[element];
    size = 0;
    while(current){
        if(current == '\\'){
            new_str[size] = '\\';
            size++;
        }
        new_str[size] = current;
        element++;
        current = str[element];
        size++;
    }
    
    return new_str;
    
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

char* createCVariantFor(char* str1) {
    if (!strcmp("writeln",str1) || !strcmp("write",str1)){
        char* returnValue = "printf(\"";
        char* parameterListStr = "";
        ParameterListNode* current = parameterListHead.next;
        while(current){
            if(current->var.name == "str"){
                current->var.data.un_str[strlen(current->var.data.un_str)-1] = 0; //remove last element, which is '
                current->var.data.un_str++;                                       //remove first element, which is '
                returnValue = strconcat(returnValue, current->var.data.un_str);
            } else if(current->var.name == "var"){
                returnValue = strconcat(returnValue, "%d");
                parameterListStr = strconcat(parameterListStr, strconcat(", ",current->var.data.un_str));
            }
            current = current->next;
        }
        if(!strcmp("writeln",str1))
            returnValue = strconcat(returnValue, "\\n\"");
        else
            returnValue = strconcat(returnValue, "\"");
        returnValue = strconcat(returnValue, strconcat(parameterListStr,");"));
        cleanParameterList();
        return returnValue;
    } else if (!strcmp("readln",str1) || !strcmp("read",str1)) {
        char* returnValue = "scanf(\"";
        char* parameterListStr = "";
        ParameterListNode* current = parameterListHead.next;
        
        while(current){
            if(current->var.name == "var"){
                if(current->next)
                    returnValue = strconcat(returnValue, "%d ");
                else
                    returnValue = strconcat(returnValue, "%d");
                parameterListStr = strconcat(parameterListStr, strconcat(", &",current->var.data.un_str));
            }
            current = current->next;
        }
        returnValue = strconcat(returnValue, "\"");
        returnValue = strconcat(returnValue, strconcat(parameterListStr,");"));
        if(!strcmp("readln",str1))
            returnValue = strconcat(returnValue, "fflush(stdin);");            
        
        cleanParameterList();
        return returnValue;
    } else
	    return str1;
    
}

void generateHeader() {
    printf("#include <stdio.h>\n");
    return;
}
