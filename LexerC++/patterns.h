#include <regex>

std::regex breakpoint_pattern(R"((.*)\s)");
std::regex comment_start(R"(//)");
std::regex multi_comment_start(R"(\/\*)");
std::regex keyword_pattern(R"(\b(abstract|as|base|bool|break|byte|case|catch|char|checked|class|const|continue|decimal|default|delegate|do|double|else|enum|event|explicit|extern|false|finally|fixed|float|for|foreach|goto|if|implicit|in|int|interface|internal|is|lock|long|namespace|new|null|object|operator|out|override|params|private|protected|public|readonly|ref|return|sbyte|sealed|short|sizeof|stackalloc|static|string|struct|switch|this|throw|true|try|typeof|uint|ulong|unchecked|unsafe|ushort|using|using static|virtual|void|volatile|while)\b)");
std::regex operator_pattern(R"(\+|\-|\*|\/|\%|\=|\+=|\-=|\*=|\/=|\%=|\+\+|\-\-|\=\=|\!|\&\&|\|\||\>|\<|\>\=|\<\=|\!\=|\&|\||\^|\~|\<<|\>>|\.|\(|\)|\[|\]|\{|\}|\;|,)");
std::regex string_start(R"(\")");
std::regex number(R"(\d+)");
