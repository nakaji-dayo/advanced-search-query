
/* description: Parses and executes mathematical expressions. */

/* lexical grammar */
%lex
%%

/* (?!.*(\s|tag:|q:)).+              { return "WORD" } */
","                 { return "COMMA" }
"tag:"              { return "TAG_KEY" }
"q:"                { return "Q_KEY" }
\s+                 { return "SPACE" }
<<EOF>>             { return "EOF" }
/* \w+ { return "WORD" } */
/* (?!.*(\s|tag:|q:|\,)).+ {return "WORD"} */
[^\s,]+ return "WORD"

/lex

/* operator associations and precedence */

%start expressions

%% /* language grammar */

expressions
  : QUERY EOF
    { typeof console !== 'undefined' ? console.log($1) : print($1);
      return $1;}
  ;

QUERY
  : MAP
  { $$ = $1 }
;

MAP
  : PAIR SPACE MAP
    { $$ = merge($1, $3) }
  | PAIR
    { $$ = $1 }
  ;

PAIR
  : TAG_KEY SET
    { $$ = {tag: $2} }
  | Q_KEY SET
    { $$ = {q: $2} }
  | TERM
    { $$ = {q: [$1]} }
;

SET
  : TERM COMMA SET
  { $$ = [ $1 ].concat($3) }
  | TERM
  { $$ = [$1] }
;

TERMS
  : TERM SPACE TERMS
    { $$ = [ $1 ].concat($3) }
  | TERM
    { $$ = [ $1 ] }
  ;

TERM
  : WORD
      {$$ = $1}
  ;

%%

const isNull = xs => !xs || xs.length == 0;

const mergeArray = (xs, ys) => (
  !isNull(xs) && !isNull(ys) ? xs.concat(ys) : !isNull(xs) ? xs : !isNull(ys) ? ys : []
);

const deepMerge = (ks) => (x, y) =>
        ks.reduce((acc, k) =>
                  Object.assign(acc, {[k]: mergeArray(x[k], y[k])})
                  , {});

const merge = deepMerge(['q', 'tag']);
