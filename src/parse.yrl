Nonterminals expr.
Terminals int '+' '*' '(' ')'.
Rootsymbol expr.

Left 200 '+'.
Left 100 '*'.
expr -> expr '+' expr      : {plus, '$1', '$3'}.
expr -> expr '*' expr      : {mult, '$1', '$3'}.
expr -> '(' expr ')'    : '$2'.
expr -> int          : '$1'. 
