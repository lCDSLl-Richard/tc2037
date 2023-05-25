#include <vector>
#include <fstream>
#include <iostream>
#include "patterns.h"
#include "token.h"

class Tokenizer
{
public:
  std::vector<Token> tokens;
  Tokenizer(){};

  void tokenize(std::string filename)
  {
    std::ifstream file(filename);
    if (!file.is_open())
    {
      return;
    }
    std::string buffer;
    std::string next;
    while (file.peek() != EOF)
    {
      buffer += file.get();
      next = file.peek();
      if (std::regex_match(buffer + next, multi_comment_start))
      {
        while (buffer.back() != '*' || file.peek() != '/')
        {
          buffer += file.get();
        }
        buffer += file.get();
        tokens.push_back(Token(COMMENT, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer + next, comment_start))
      {
        while (file.peek() != '\n' && file.peek() != EOF)
        {
          buffer += file.get();
        }
        tokens.push_back(Token(COMMENT, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer, string_start))
      {
        while (file.peek() != '"')
        {
          buffer += file.get();
        }
        buffer += file.get();
        tokens.push_back(Token(STRING, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer, number))
      {
        while (std::regex_match(next, number))
        {
          buffer += file.get();
          next = file.peek();
        }
        tokens.push_back(Token(INTEGER, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer, keyword_pattern) && next == " ")
      {
        tokens.push_back(Token(KEYWORD, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer, operator_pattern))
      {
        tokens.push_back(Token(OPERATOR, buffer));
        buffer.clear();
      }
      else if (std::regex_match(buffer, breakpoint_pattern))
      {
        tokens.push_back(Token(NONE, buffer));
        buffer.clear();
      }
      else if (std::regex_match(next, breakpoint_pattern))
      {
        tokens.push_back(Token(IDENTIFIER, buffer));
        buffer.clear();
      }
      else if (std::regex_match(next, operator_pattern))
      {
        tokens.push_back(Token(IDENTIFIER, buffer));
        buffer.clear();
      }
    }
    file.close();
  }

  void output(std::string filename)
  {
    std::ofstream file(filename);
    if (!file.is_open())
    {
      return;
    }
    file << "<head><link rel='stylesheet' href='../style.css'></head><body><pre>";
    for (auto token : tokens)
    {
      token.type != NONE ? file << "<span class='" << token.enum_to_string() << "'>" << token.value << "</span>" : file << token.value;
    }
    file << "</pre></body>";
    file.close();
  }
};
