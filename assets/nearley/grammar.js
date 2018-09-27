// Generated automatically by nearley, version 2.15.1
// http://github.com/Hardmath123/nearley
(function () {
function id(x) { return x[0]; }

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


  function justText(d, ofType) {
    var flatd = [].concat.apply([], d).filter(v=>v); // flatten  and then filter nulls
    return { ofType: ofType, text: flatd.reduce(function(acc, el){ return acc += el.text; }, "") };
  }
var grammar = {
    Lexer: lexer,
    ParserRules: [
    {"name": "main", "symbols": ["ref"]},
    {"name": "main", "symbols": ["scripture"]},
    {"name": "main", "symbols": ["sentences"]},
    {"name": "main", "symbols": ["quotation"]},
    {"name": "main", "symbols": ["fragment"]},
    {"name": "main", "symbols": ["words"]},
    {"name": "main", "symbols": ["word"]},
    {"name": "main", "symbols": ["chapVs"]},
    {"name": "scripture", "symbols": ["sentences", "ref"], "postprocess": ([scripture, ref]) => { return { ofType: 'scripture', text: scripture.text, ref: ref.text } }},
    {"name": "ref$ebnf$1", "symbols": [(lexer.has("number") ? {type: "number"} : number)], "postprocess": id},
    {"name": "ref$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "ref$ebnf$2", "symbols": [(lexer.has("ws") ? {type: "ws"} : ws)], "postprocess": id},
    {"name": "ref$ebnf$2", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "ref", "symbols": ["ref$ebnf$1", "ref$ebnf$2", "words", (lexer.has("ws") ? {type: "ws"} : ws), "chapVs"], "postprocess": d => justText(d, 'ref')},
    {"name": "sentences", "symbols": ["fragment", (lexer.has("eosentence") ? {type: "eosentence"} : eosentence)], "postprocess": d => justText(d, 'sentences')},
    {"name": "sentences$ebnf$1", "symbols": [(lexer.has("ws") ? {type: "ws"} : ws)], "postprocess": id},
    {"name": "sentences$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "sentences", "symbols": ["fragment", (lexer.has("punc") ? {type: "punc"} : punc), "sentences$ebnf$1", "quotation"], "postprocess": d => justText(d, 'sentences')},
    {"name": "quotation", "symbols": [(lexer.has("quote") ? {type: "quote"} : quote), "fragment", (lexer.has("quote") ? {type: "quote"} : quote)], "postprocess": d => justText(d, 'quotation')},
    {"name": "quotation", "symbols": [(lexer.has("quote") ? {type: "quote"} : quote), "fragment", (lexer.has("eosentence") ? {type: "eosentence"} : eosentence), (lexer.has("quote") ? {type: "quote"} : quote)], "postprocess": d => justText(d, 'quotation')},
    {"name": "fragment", "symbols": ["words"], "postprocess": d => justText(d, 'fragment')},
    {"name": "fragment", "symbols": ["fragment", (lexer.has("punc") ? {type: "punc"} : punc), (lexer.has("ws") ? {type: "ws"} : ws), "words"], "postprocess": d => justText(d, 'fragment')},
    {"name": "words", "symbols": ["word"], "postprocess": d => justText(d, 'words')},
    {"name": "words", "symbols": ["words", (lexer.has("ws") ? {type: "ws"} : ws), "word"], "postprocess": d => justText(d, 'words')},
    {"name": "word", "symbols": [(lexer.has("letters") ? {type: "letters"} : letters), (lexer.has("hack") ? {type: "hack"} : hack), (lexer.has("letters") ? {type: "letters"} : letters)], "postprocess": d => justText(d, 'word')},
    {"name": "word", "symbols": [(lexer.has("letters") ? {type: "letters"} : letters), (lexer.has("dash") ? {type: "dash"} : dash), (lexer.has("letters") ? {type: "letters"} : letters)], "postprocess": d => justText(d, 'word')},
    {"name": "word", "symbols": [(lexer.has("letters") ? {type: "letters"} : letters)], "postprocess": d => justText(d, 'word')},
    {"name": "chapVs$ebnf$1", "symbols": [(lexer.has("ws") ? {type: "ws"} : ws)], "postprocess": id},
    {"name": "chapVs$ebnf$1", "symbols": [], "postprocess": function(d) {return null;}},
    {"name": "chapVs", "symbols": [(lexer.has("number") ? {type: "number"} : number), (lexer.has("colon") ? {type: "colon"} : colon), (lexer.has("number") ? {type: "number"} : number), "chapVs$ebnf$1", (lexer.has("dash") ? {type: "dash"} : dash), (lexer.has("number") ? {type: "number"} : number)], "postprocess": d => justText(d, 'chapVs')},
    {"name": "chapVs", "symbols": [(lexer.has("number") ? {type: "number"} : number), (lexer.has("colon") ? {type: "colon"} : colon), (lexer.has("number") ? {type: "number"} : number)], "postprocess": d => justText(d, 'chapVs')},
    {"name": "chapVs", "symbols": [(lexer.has("number") ? {type: "number"} : number)], "postprocess": d => justText(d, 'chapVs')}
]
  , ParserStart: "main"
}
if (typeof module !== 'undefined'&& typeof module.exports !== 'undefined') {
   module.exports = grammar;
} else {
   window.grammar = grammar;
}
})();
