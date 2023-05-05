#lang racket

;;; Authors: Ricardo Adolfo Fernández Alvarado - A01704813
;;;          Damariz Licea Carrisoza - A01369045

;;; Imports
(require 2htdp/batch-io)

;;; Timing
(define start-time (current-inexact-milliseconds))

;;; Reading File
(define fileString (read-file "test3.txt"))

;;; Regular expressions
;;; -------------------
;;; Comments
(define commentExpression (regexp "<[^/>]*>//</[^>]*>[^\n]*|<[^/>]*>/\\*</[^>]*>.*<[^/>]*>\\*/</[^>]*>"))
;;; Operators
(define operators
  (list "{"
        "}"
        "["
        "]"
        "("
        ")"
        "."
        ","
        ":"
        ";"
        "+"
        "-"
        "*"
        "/"
        "%"
        "&"
        "|"
        "^"
        "!"
        "~"
        "="
        "<"
        ">"
        "?"
        "??"
        "::"
        "++"
        "--"
        "&&"
        "||"
        "->"
        "=="
        "!="
        "<="
        ">="
        "+="
        "-="
        "*="
        "/="
        "%="
        "&="
        "|="
        "^="
        "<<"
        "<<="
        "=>"))
(define operatorExpression
  (regexp (string-append "(" (string-join (map regexp-quote operators) "|") ")+")))
;;; Keywords
(define keywords
  (list "var"
        "abstract"
        "as"
        "base"
        "bool"
        "break"
        "byte"
        "case"
        "catch"
        "char"
        "checked"
        "const"
        "continue"
        "decimal"
        "default"
        "delegate"
        "do"
        "double"
        "else"
        "enum"
        "event"
        "explicit"
        "extern"
        "false"
        "finally"
        "fixed"
        "float"
        "for"
        "foreach"
        "goto"
        "if"
        "implicit"
        "in"
        "int"
        "interface"
        "internal"
        "is"
        "lock"
        "long"
        "namespace"
        "new"
        "null"
        "object"
        "operator"
        "out"
        "override"
        "params"
        "private"
        "protected"
        "public"
        "readonly"
        "ref"
        "return"
        "sbyte"
        "sealed"
        "short"
        "sizeof"
        "stackalloc"
        "static"
        "string"
        "struct"
        "switch"
        "this"
        "throw"
        "true"
        "try"
        "typeof"
        "uint"
        "ulong"
        "unchecked"
        "unsafe"
        "ushort"
        "using"
        "virtual"
        "void"
        "volatile"
        "while"
        "class"))
(define keywordsExpression
  (pregexp (string-append "(?![^<]*>)\\b(" (string-join (map regexp-quote keywords) "|") ")\\b")))
;;; Character
(define single-character "[^'\\\\(\\\n)]")
(define single-string-character "([^\"\\\\])")
(define simple-escape-sequence "\\\\['\"\\\\abfnrtv0]")
(define hex-digit "[0-9a-fA-F]")
(define hexadecimal-escape-sequence
  (string-join(list "\\\\x"
                    hex-digit hex-digit "?" hex-digit "?" hex-digit "?") ""))
(define unicode-escape-sequence
  (string-join(list "(\\\\u"
                    hex-digit hex-digit hex-digit hex-digit ")"
                    "|"
                    "(\\\\U" hex-digit hex-digit hex-digit hex-digit
                    hex-digit hex-digit hex-digit hex-digit ")") ""))
(define character (string-join (list single-character simple-escape-sequence hexadecimal-escape-sequence unicode-escape-sequence) "|"))
(define charExpression (regexp (string-join (list "'(" character ")'") "")))
;;; String
(define regular-string-char (string-append "(" single-string-character "|" simple-escape-sequence "|" hexadecimal-escape-sequence "|" unicode-escape-sequence ")"))
(define regular-string (string-join (list "\"" "(" regular-string-char ")*" "\"") ""))
(define verbatim-string (string-join (list "@\"" "([^\"])*" "\"") ""))
(define stringExpression (regexp (string-join (list regular-string "|" verbatim-string) "")))
;;; Integer
(define decimal-digit "[0-9]")
(define decorated-decimal-digit (string-join (list "(_*" decimal-digit ")") ""))
(define int-type "([uU][lL]?|[lL][uU]?)")
(define decimal-integer (string-join (list decimal-digit decorated-decimal-digit "*" int-type "?") ""))
(define decorated-hex-digit (string-join (list "(_*" hex-digit ")") ""))
(define hex-integer (string-join (list "0[xX]" decorated-hex-digit "+" int-type "?") ""))
(define binary-digit "[01]")
(define decorated-binary-digit (string-join (list "(_*" binary-digit ")") ""))
(define binary-integer (string-join (list "0[bB]" decorated-binary-digit "+" int-type "?") ""))
(define integer (pregexp (string-join (list "\\b(" hex-integer "|" binary-integer "|" decimal-integer ")\\b") "")))
;;; Real
(define sign "(<[^/>]*>(\\+|-)</[^>]*>)")
(define real-type "[fFdDmM]")
(define point "(<[^/>]*>\\.</[^>]*>)")
(define exponent (string-join (list "([eE]" sign "?" decimal-digit decorated-decimal-digit "*)") ""))
(define real (pregexp (string-join (list "\\s(" decimal-digit decorated-decimal-digit "*" point decimal-digit decorated-decimal-digit "*" exponent "?" real-type "?|" point decimal-digit decorated-decimal-digit "*" exponent "?" real-type "?|" decimal-digit decorated-decimal-digit "*" exponent real-type "?|" decimal-digit decorated-decimal-digit "*" real-type ")\\b") "")))

;;; Auxiliary functions
;;; -------------------
;;; Wrapper for spans
(define wordWrapper
  (lambda (class)
    (lambda s
      (string-join (list "<span class=" class ">" (first s) "</span>") ""))))

;;; Apply regex to string
(define applyRegex
  (lambda (inputString regExp className)
    (regexp-replace* regExp inputString (wordWrapper className))))

;;; Text processing
(define output  (applyRegex (applyRegex (applyRegex (applyRegex (applyRegex (applyRegex (applyRegex fileString operatorExpression "'operator'") commentExpression "'comment'") keywordsExpression "'keyword'") charExpression "'char'") stringExpression "'string'") real "'real'") integer "'integer'"))

(define finalOutput (string-append "<head> <link rel='stylesheet' href='styles.css'> <title>problemSituation</title> </head><pre>" output "</pre>"))

;;; File Writing
(write-file "output.html" finalOutput)

;;; Time calculation
(define total-time (/ (- (current-inexact-milliseconds) start-time) 1000))