#include <sstream>
#include "tokenizer.h"

int main(int argc, char *argv[])
{
  Tokenizer tokenizer;
  for (int i = 1; i < 101; i++)
  {
    std::stringstream ss;
    if (i < 10)
      ss << "cs_codes/code0" << i << ".cs";
    else
      ss << "cs_codes/code" << i << ".cs";
    tokenizer.tokenize(ss.str());
    ss.str(std::string());
    ss << "output_codes/output" << i << ".html";
    tokenizer.output(ss.str());
    tokenizer.tokens.clear();
  }
  return 0;
}
