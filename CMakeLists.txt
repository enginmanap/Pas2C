cmake_minimum_required(VERSION 2.8.5)

project(Pascal)

find_program(LEX_EXE
    flex
)
if(LEX_EXE STREQUAL "LEX_EXE-NOTFOUND")
    message(FATAL_ERROR "dear user, plase install flex!")
endif(LEX_EXE STREQUAL "LEX_EXE-NOTFOUND")

find_program(YACC_EXE
    bison
)
if(YACC_EXE STREQUAL "YACC_EXE-NOTFOUND")
    message(FATAL_ERROR "dear user, plase install bison!")
endif(YACC_EXE STREQUAL "YACC_EXE-NOTFOUND")

# reuseable cmake macro for yacc
MACRO(YACC_FILE)
 ADD_CUSTOM_COMMAND(
   SOURCE ${PROJECT_SOURCE_DIR}/src/pascal.l
   COMMAND ${LEX_EXE} 
   ARGS -o${PROJECT_BINARY_DIR}/comp/pascal_lexer.c
        ${PROJECT_SOURCE_DIR}/src/pascal.l
   TARGET FooParser
   OUTPUTS ${PROJECT_BINARY_DIR}/comp/pascal_lexer.c)

ENDMACRO(YACC_FILE)

# reuseable cmake macro for lex
MACRO(LEX_FILE)
 ADD_CUSTOM_COMMAND(
   SOURCE ${PROJECT_SOURCE_DIR}/src/pascal.y
   COMMAND ${YACC_EXE} 
   ARGS -o${PROJECT_BINARY_DIR}/comp/y.tab.c
   -y -d -v ${PROJECT_SOURCE_DIR}/src/pascal.y
   TARGET FooParser
   DEPENDS ${PROJECT_BINARY_DIR}/comp/pascal_lexer.c
   OUTPUTS ${PROJECT_BINARY_DIR}/comp/y.tab.c
   	   ${PROJECT_BINARY_DIR}/comp/y.tab.h)

ENDMACRO(LEX_FILE)

# just one more parsing executable
file(MAKE_DIRECTORY comp)

FILE(COPY ${PROJECT_SOURCE_DIR}/src/custom.h
     DESTINATION ${PROJECT_BINARY_DIR}/comp/)

FILE(COPY ${PROJECT_SOURCE_DIR}/src/converter.sh
     DESTINATION ${PROJECT_BINARY_DIR}/)

YACC_FILE()
LEX_FILE()
# Add parser.c to the list of sources
 SET(PROJECT_SRCS ${PROJECT_SRCS} ${PROJECT_BINARY_DIR}/comp/y.tab.c)
 SET(PROJECT_SRCS ${PROJECT_SRCS} ${PROJECT_BINARY_DIR}/comp/y.tab.h)

# Since parser.c does not exists yet when cmake is run, mark
# it as generated
 SET_SOURCE_FILES_PROPERTIES(${PROJECT_BINARY_DIR}/comp/y.tab.c GENERATED)

# Include binary directory to include lexer.c in parser.c
 INCLUDE_DIRECTORIES(${PROJECT_BINARY_DIR}/comp/)

add_executable(pas2c
    ${PROJECT_BINARY_DIR}/comp/y.tab.c
    ${PROJECT_BINARY_DIR}/comp/pascal_lexer.c
)
