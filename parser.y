%code requires {
    #include <stdio.h>
    #include <string>

    int yylex();
    int yyerror(char *s);
}

%union{
	std::string* text;
}

%token <text> IDENTIFIER
%token NUMBER_TYPE STRING_TYPE
%token <text> NUMBER
%token <text> STRING
%token LET
%token EQUALS
%token COLON
%token SEMICOLON
%token PLUS MINUS MULTIPLY DIVIDE
%token L_BRACKET R_BRACKET
%token L_C_BRACKET R_C_BRACKET
%token L_S_BRACKET R_S_BRACKET
%token CONSOLE_LOG
%token FUNCTION
%token COMMA
%token RETURN

%token IF  
%token FOR

%token COMPARE LESS MORE LESS_EQ MORE_EQ


%type <text> prog
%type <text> statement
%type <text> expression
%type <text> arguments

%start start

%%
start:
    prog {
        printf("#include <iostream>\n\n%s\n", $1->c_str());
        delete $1;
    }
;
prog:
    statement prog {
        $$ = new std::string(*$1 + *$2);
        delete $1;
        delete $2;
    } |
    statement {
        $$ = new std::string(*$1);
        delete $1;
    }
    
;

statement:
    FUNCTION IDENTIFIER L_BRACKET arguments R_BRACKET COLON NUMBER_TYPE {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "(" + *$4 + ")");
        else
            $$ = new std::string("double " + *$2 + "(" + *$4 + ")");
        delete $2;
        delete $4;
    } |
    FUNCTION IDENTIFIER L_BRACKET arguments R_BRACKET COLON STRING_TYPE {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "(" + *$4 + ")");
        else
            $$ = new std::string("std::string " + *$2 + "(" + *$4 + ")");
        delete $2;
        delete $4;
    } |
    FUNCTION IDENTIFIER L_BRACKET arguments R_BRACKET {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "(" + *$4 + ")");
        else
            $$ = new std::string("void " + *$2 + "(" + *$4 + ")");
        delete $2;
        delete $4;
    } |
    FUNCTION IDENTIFIER L_BRACKET R_BRACKET COLON NUMBER_TYPE {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "()");
        else
            $$ = new std::string("double " + *$2 + "()");
        delete $2;
    } |
    FUNCTION IDENTIFIER L_BRACKET R_BRACKET COLON STRING_TYPE {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "()");
        else
            $$ = new std::string("std::string " + *$2 + "()");
        delete $2;
    } |
    FUNCTION IDENTIFIER L_BRACKET R_BRACKET {
        if(*$2 == "main")
            $$ = new std::string("int " + *$2 + "()");
        else
            $$ = new std::string("void " + *$2 + "()");
        delete $2;
    } |
    CONSOLE_LOG L_BRACKET expression R_BRACKET {
        $$ = new std::string("std::cout << " + *$3 + " << '\\n'");
        delete $3;
    } |
    LET IDENTIFIER COLON NUMBER_TYPE EQUALS expression {
        $$ = new std::string("double " + *$2 + " = " + *$6 );
        delete $2;
        delete $6;
    } |
    LET IDENTIFIER COLON STRING_TYPE EQUALS expression {
        $$ = new std::string("std::string " + *$2 + " = " + *$6);
        delete $2;
        delete $6;
    } |
    LET IDENTIFIER COLON NUMBER_TYPE {
        $$ = new std::string("double " + *$2 );
        delete $2;
    } |
    LET IDENTIFIER COLON STRING_TYPE {
        $$ = new std::string("std::string " + *$2);
        delete $2;
    } |
    IDENTIFIER COLON NUMBER_TYPE EQUALS expression {
        $$ = new std::string("double " + *$1 + " = " + *$5 );
        delete $1;
        delete $5;
    } |
    IDENTIFIER COLON STRING_TYPE EQUALS expression {
        $$ = new std::string("std::string " + *$1 + " = " + *$5);
        delete $1;
        delete $5;
    } |
    IDENTIFIER COLON NUMBER_TYPE {
        $$ = new std::string("double " + *$1 );
        delete $1;
    } |
    IDENTIFIER COLON STRING_TYPE {
        $$ = new std::string("std::string " + *$1);
        delete $1;
    } |
    IF L_BRACKET expression R_BRACKET {
        $$ = new std::string("if(" + *$3 + ")");
        delete $3;
    } |
    FOR L_BRACKET statement SEMICOLON expression SEMICOLON statement R_BRACKET {
        $$ = new std::string("for(" + *$3 + "; " + *$5 + "; " + *$7 + ")\n");
        delete $3;
        delete $5;
        delete $7;
    } |
    RETURN expression {
        $$ = new std::string("return " + *$2);
        delete $2;
    } |
    RETURN {
        $$ = new std::string("return");
    } |
    expression {
        $$ = new std::string(*$1);
        delete $1;
    } |
    L_C_BRACKET {
        $$ = new std::string("{\n");
    } |
    R_C_BRACKET {
        $$ = new std::string("}\n");
    } |
    IDENTIFIER EQUALS expression {
        $$ = new std::string(*$1 + " = " + *$3);
        delete $1;
        delete $3;
    } |
    SEMICOLON {
        $$ = new std::string(";\n");
    }
;
arguments:
    statement {
        $$ = new std::string(*$1);
        delete $1;
    } |
    statement COMMA arguments {
        $$ = new std::string(*$1 + *$3);
        delete $1;
        delete $3;
    }
;
expression:
    expression PLUS expression {
        $$ = new std::string(*$1 + " + " + *$3);
        delete $1;
        delete $3;
    } |
    expression MINUS expression {
        $$ = new std::string(*$1 + " - " + *$3);
        delete $1;
        delete $3;

    } |
    expression DIVIDE expression {
        $$ = new std::string(*$1 + " / " + *$3);
        delete $1;
        delete $3;

    } |
    expression MULTIPLY expression {
        $$ = new std::string(*$1 + " * " + *$3);
        delete $1;
        delete $3;

    } |
    expression COMPARE expression {
        $$ = new std::string(*$1 + " == " + *$3);
        delete $1;
        delete $3;

    } |
    expression LESS expression {
        $$ = new std::string(*$1 + " < " + *$3);
        delete $1;
        delete $3;

    } |
    expression LESS_EQ expression {
        $$ = new std::string(*$1 + " <= " + *$3);
        delete $1;
        delete $3;

    } |
    expression MORE expression {
        $$ = new std::string(*$1 + " > " + *$3);
        delete $1;
        delete $3;

    } |
    expression MORE_EQ expression {
        $$ = new std::string(*$1 + " >= " + *$3);
        delete $1;
        delete $3;

    } |
    IDENTIFIER L_BRACKET expression R_BRACKET {
        $$ = new std::string(*$1 + "(" + *$3 + ")");
        delete $1;
        delete $3;
    } |
    L_BRACKET expression R_BRACKET {
        $$ = new std::string("(" + *$2 + ")");
        delete $2;
    } |
    IDENTIFIER L_S_BRACKET expression R_S_BRACKET {
        $$ = new std::string(*$1 + "[" + *$3 + "]");
        delete $1;
        delete $3;
    } |
    NUMBER {
        $$ = new std::string(*$1);
        delete $1;
    } |
    IDENTIFIER {
        $$ = new std::string(*$1);
        delete $1;
    } |
    STRING {
        $$ = new std::string(*$1);
        delete $1;
    }
;

%%

int yyerror(char *s)
{
	printf("Syntax Error on line %s\n", s);
	return 0;
}

int main()
{
    yyparse();
    return 0;
}