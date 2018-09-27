# welp nearly grammar

@{%
const moo = require("moo");
// FYI \u201C - left curly quote; \u201D - right curly quote
const lexer = moo.compile({
  ws: {match: /[ \t\n\r]+/, lineBreaks: true},
  number: /[0-9]+/,
  letters: /[a-zA-Z]+/,
  times: /\*|x/,
  colon: /\:/,
  hack: /\'/,
  dash: /-/,
  eosentence: /[\.\!\?][\s]?/,
  punc: /[\,\;\:\*]/,
  star: /\*/,
  quote: /[\"\u201C\u201D]/
});
%}

@{%
  function justText(d, ofType) {
    var flatd = [].concat.apply([], d).filter(v=>v); // flatten  and then filter nulls
    return { ofType: ofType, text: flatd.reduce(function(acc, el){ return acc += el.text; }, "") };
  }
%}

# passlexer object using @lexar option:
@lexer lexer

main ->
    ref
  | scripture
  | sentences
  | quotation
  | fragment
  | words
  | word
  | chapVs

scripture ->
  sentences ref  {% ([scripture, ref]) => { return { ofType: 'scripture', text: scripture.text, ref: ref.text } } %}

ref ->
  %number:? %ws:? words %ws chapVs   {% d => justText(d, 'ref') %}

sentences ->
      fragment %eosentence              {% d => justText(d, 'sentences') %}
    | fragment %punc %ws:? quotation    {% d => justText(d, 'sentences') %}

quotation ->
    %quote fragment %quote              {% d => justText(d, 'quotation') %}
  | %quote fragment %eosentence %quote  {% d => justText(d, 'quotation') %}

fragment ->
    words                   {% d => justText(d, 'fragment') %}
  | fragment %punc %ws words    {% d => justText(d, 'fragment') %}

words ->
    word              {% d => justText(d, 'words') %}
  | words %ws word   {% d => justText(d, 'words') %}

word -> 
    %letters %hack %letters {% d => justText(d, 'word') %}
  | %letters %dash %letters {% d => justText(d, 'word') %}
  | %letters                {% d => justText(d, 'word') %}

chapVs ->
    %number %colon %number %ws:? %dash %number  {% d => justText(d, 'chapVs') %}
  | %number %colon %number                      {% d => justText(d, 'chapVs') %}
  | %number                                     {% d => justText(d, 'chapVs') %}