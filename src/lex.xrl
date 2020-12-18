Definitions.
Rules.
[0-9]+ : {token, {int, TokenLine, list_to_integer(TokenChars)}}.
\( : {token, {'(', TokenLine}}.
\) : {token, {')', TokenLine}}.
\+ : {token, {'+', TokenLine}}.
\* : {token, {'*', TokenLine}}.
[\s\n\r\t]+           : skip_token.

Erlang code.