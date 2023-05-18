#include <sstream>
#include "tokenizer.h"

int main(int argc, char *argv[])
{
  Tokenizer tokenizer;
  tokenizer.tokenize("cs_codes/code59.cs");
  tokenizer.output("output.html");
  return 0;
}
