%{
#include <stdio.h>
#include <string.h>
#include "parser.hpp"
%}


numbers     [0-9]+
alpha       [a-zA-Z]+
alpha_num   [a-zA-Z][a-zA-Z0-9]*

%%

[ \t]*\n {

}

"\""[^\"]*?"\"" {
    yylval.text = new std::string(yytext);
    return (STRING);
}

"console.log" {
    return (CONSOLE_LOG);
}
"function" {
    return (FUNCTION);
}
"return" {
    return (RETURN);
}

"let" {
    return (LET);
}

"number" {
    return (NUMBER_TYPE);
}

"string" {
    return (STRING_TYPE);
}
"if" {
    return (IF);
}
"for" {
    return (FOR);
}
";" {
    return (SEMICOLON);
}
"," {
    return (COMMA);
}

":" {
    return (COLON);
}

"=" {
    return (EQUALS);
}

"+" {
    return (PLUS);
}
"-" {
    return (MINUS);
}
"/" {
    return (DIVIDE);
}
"*" {
    return (MULTIPLY);
}
"==" {
    return (COMPARE);
}
"<" {
    return (LESS);
}
"<=" {
    return (LESS_EQ);
}
">" {
    return (MORE);
}
">=" {
    return (MORE_EQ);
}
"{" {
    return (L_C_BRACKET);
}
"}" {
    return (R_C_BRACKET);
}
"(" {
    return (L_BRACKET);
}
")" {
    return (R_BRACKET);
}
"[" {
    return (L_S_BRACKET);
}
"]" {
    return (R_S_BRACKET);
}


{alpha_num} {
    yylval.text = new std::string(yytext);
    //sscanf(yytext, "%s", yylval.text);
    return (IDENTIFIER);
}

{numbers} {
    yylval.text = new std::string(yytext);
    return (NUMBER);
}


%%
