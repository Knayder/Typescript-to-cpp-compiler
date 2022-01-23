mkdir build
bison -d parser.y -o build/parser.cpp
flex -o build/tokenizer.cpp tokenizer.l

g++ -o compiler build/parser.cpp build/tokenizer.cpp -ll -lm -w

mkdir output
./compiler < input.ts > output/output.cpp
g++ -o output/output.exe output/output.cpp
./output/output.exe

