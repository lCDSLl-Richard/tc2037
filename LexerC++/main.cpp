#include <sstream>
#include "utils.h"
#include "tokenizer.h"

const int THREADS = 8;

typedef struct
{
  int start, end;
} Info;

void *parallel_tokenize(void *params)
{
  Info *info = (Info *)params;

  Tokenizer tokenizer;
  for (int i = info->start; i < info->end; i++)
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
  pthread_exit(0);
}

int main(int argc, char *argv[])
{
  start_timer();
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
  double elapsed = stop_timer();
  std::cout << "Single Thread" << std::endl;
  std::cout << "Elapsed time: " << elapsed << " seconds" << std::endl;

  start_timer();
  pthread_t threads[THREADS];
  Info info[THREADS];
  for (int i = 0; i < THREADS; i++)
  {
    info[i].start = i * 10 + 1;
    info[i].end = (i + 1) * 10 + 1;
    pthread_create(&threads[i], NULL, parallel_tokenize, (void *)&info[i]);
  }

  for (int i = 0; i < THREADS; i++)
  {
    pthread_join(threads[i], NULL);
  }

  elapsed = stop_timer();
  std::cout << "Multi Thread" << std::endl;
  std::cout << "Elapsed time: " << elapsed << " seconds" << std::endl;
  return 0;
}
