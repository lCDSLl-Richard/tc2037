#include <string>

enum Type
{
  IDENTIFIER,
  KEYWORD,
  INTEGER,
  REAL,
  CHARACTER,
  STRING,
  OPERATOR,
  COMMENT,
  FUNCTION,
  NONE
};

class Token
{
public:
  Type type;
  std::string value;

  Token(Type type, std::string value)
  {
    this->type = type;
    this->value = value;
  };

  std::string enum_to_string()
  {
    switch (type)
    {
    case IDENTIFIER:
      return "IDENTIFIER";
      break;

    case KEYWORD:
      return "KEYWORD";
      break;

    case INTEGER:
      return "INTEGER";
      break;

    case REAL:
      return "REAL";
      break;

    case CHARACTER:
      return "CHARACTER";
      break;

    case STRING:
      return "STRING";
      break;

    case OPERATOR:
      return "OPERATOR";
      break;

    case COMMENT:
      return "COMMENT";
      break;

    case FUNCTION:
      return "FUNCTION";
      break;

    default:
      return "NO TYPE";
      break;
    }
  }
};
