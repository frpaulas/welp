// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

import $ from 'jquery';
import Elm from './main'
const elmDiv = document.getElementById('elm-main')
  , elmApp = Elm.Main.embed(elmDiv)
  , port = elmApp.ports
  ;
const nearley = require("nearley");
const grammar = require("../nearley/grammar.js");
// const parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar), {keepHistory: true});
const widgets = require("./widgets.js");

var lastSelection = "";

port.scrollDownRequest.subscribe( function(_dontcare){
  var $rightSide = $('#rightSide')
  $rightSide.animate({ scrollTop: $rightSide.height() }, "slow");
})

port.requestSelection.subscribe( function(ofType) {
  var parser = new nearley.Parser(nearley.Grammar.fromCompiled(grammar));
  var $obj = $('#raw_office')
    , start = $obj[0].selectionStart
    , end = $obj[0].selectionEnd
    , rawOffice = $obj.val()
    , $preview = $("#preview")
    ;


  end = (rawOffice[end] == '\n') ? end + 1 : end;
  // make the string simple, 
  // change \n to a space and trim leading/trailing whitespace
  var selText = rawOffice.substr(start, end).replace(/\n/g, ' ').trim();

  console.log("SEL TEXT: ", rawOffice)

  if (selText.length < 1) { return };
  console.log("REQUEST SELECTION: ", [ofType, selText])
  var s = '';
  switch (ofType) {
    case 'scripture':
      try {
        parser.feed(selText);
      } catch(err) {
        console.log("Error at character " + err);
        console.log("Error PARSER ", parser.table);
        alert(err);
        return null;
      }
      var q = parser.results[0][0];
      console.log("PARSED: ", q)
      widgets.pageAppend($preview, ofType, q.text, q.ref)
      s = output(ofType, [q.text, q.ref]);
      break;
    default:
      widgets.pageAppend($preview, ofType, selText)
      s = output(ofType, [selText])
  }
  if (s.length > 0) {
    $obj.val( rawOffice.slice(end) );
    $preview.animate({ scrollTop: $preview.height() }, "slow");
    port.requestedSelection.send({ofType: ofType, text: s + ',', selection: selText})
  }
})

function output(ofType, list) {
  var s = "[ \'" + ofType + "\'\n";
  s = list.reduce(function(acc, l) {
        return acc += ", \'" + l + "\'\n"
      }, s)
  s += "]\n";
  return s;
}
