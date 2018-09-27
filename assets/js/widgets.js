// widgets
"use strict";

import $ from 'jquery';
var preview = null;

export function pageAppend (previewNode, ofType, ...list) {
    preview = previewNode;
    console.log("PAGE APPEND: ", list)
    switch(ofType) {
      case 'title': newTitle(list); break;
      case 'rubric': newRubric(list); break;
      case 'sectionTitle': newSection(list); break;
      case 'indent': newParagraph('indent', list); break;
      case 'indent2': newParagraph('indent2', list); break;
      case 'plaintext': newParagraph('no-indent', list); break;
      case 'noindent': newParagraph('no-indent', list); break;
      case 'song': newSong(list); break;
      case 'psalm': newPsalm(list); break;
      case 'alternatePsalm': newAlternatePsalm(list); break;
      case 'scripture': newScripture(list); break;
      case 'collect': newCollect(list); break;
      case 'canticle': newCanticle(list); break;
      case 'concludingSentence': newConcludingSentence(list); break;
      case 'theLordsPrayer': lordsPrayer(); break;
      case 'apostlesCreed': apostlesCreed(); break;
      default:
        console.log("NO MATCH FOR: ", ofType, " with ", list);
    }
}

export function pageBuild(list) {
  preview.innerHTML = ""; // rebuild the page
  list.forEach(function([ofType, ...list]) { pageAppend(ofType, list) });
}

function newElement(ofType, klass, text) {
  var node = $(ofType, {"class": klass, text: text});
//  console.log('CONTAINER: ', node)
//  $('#rightSide').appendChild(node);
//  return node;
  preview.append(node);
  return node;
}

function newDiv(klass, text) {
  return newElement('<div />', klass, text);
}

function newSpan(klass, text) {
  return newElement('<span />', klass, text);
}

function newParagraph(klass, text) {
  return newElement('<p />', klass, text);
}

function newTitle (text) {
  return newDiv('title', text);
}

function newRubric (text) {
  return newDiv('rubric', text);
}

function newSection (text) {
  return newDiv('sectionTitle', text);
}

function newIndent (text) {
  return newDiv('indent', text);
}

function newNoIndent (text) {
  return newDiv('no-indent', text);
}

// `__` means "don't care, not using"

function newSong ([title, subtitle, ...vss]) {
  var node = newDiv('song', '');
  var newVss = vss.map(function(vs){return newParagraph('no-indent', vs)});
  node.append([
      newSpan('psalm-title', title)
    , newSpan('psalm-subtitle', subtitle)
    ].concat(newVss)
    )
  return node;
}

function newPsalm ([title, ...vss]) {
  _insertPsalm('psalm', title, vss);
}

function newAlternatePsalm([title, ...vss]) {
  _insertPsalm('alternate-psalm', title, vss);
}

function _insertPsalm(psType, title, ...vss) {
  var node = newDiv(psType, '');
  node.append(newParagraph('psalm-title', title));
  // var node = newDiv(psType, psTitle);
  return node.append( psalmVss(vss) );
}

function psalmVss(vss) {
  // create a bunch of joined paragraphs from the vss
  var newVss = vss[0].map(function([a,b]) {
    return [newParagraph('psalm-vs-a', a), newParagraph('psalm-vs-b', b)];
  });
  // return a flattened array - javascript is weird
  return [].concat.apply([], newVss);
}

function newScripture([text, ref]) {
  console.log("NEW SCRIPTURE: ", [text, ref])
  var node = newDiv('scripture', text);
  node.append(newSpan('scripture-ref', ref));
  return node;
}

function newCollect([text, amen]) {
  var p = newParagraph('collect', text);
  var a = newSpan('amen', amen);
  p.append(a);
  return p;
}

function newCanticle([title, subtitle, ...lines]) {
  var node = newDiv('song', '')
  node.append(newSpan('psalm-title', title));
  node.append(newSpan('psalm-subtitle', subtitle))
  node.append(lines.map(function(l){return newParagraph('no-indent', l)}));
  return node
}

function newConcludingSentence([__, text, amen]) {
  var node = newParagraph('no-indent', text);
  node.append( newSpan('amen', amen) );
  return node;
}

function apostlesCreed() {
  var node = newDiv('creed', '');
  node.append([
      newSection('The Apostles Creed')
    , newParagraph( 'no-indent', 'I believe in God, the Father almighty,')
    , newParagraph( 'indent', 'creator of heaven and earth.')
    , newParagraph( 'no-indent', 'I believe in Jesus Christ, his only Son, our Lord.')
    , newParagraph( 'indent', 'He was conceived by the Holy Spirit')
    , newParagraph( 'indent', 'and born of the Virgin Mary.')
    , newParagraph( 'indent', 'He suffered under Pontius Pilate,')
    , newParagraph( 'indent', 'was crucified, died, and was buried.')
    , newParagraph( 'indent', 'He descended to the dead.')
    , newParagraph( 'indent', 'On the third day he rose again.')
    , newParagraph( 'indent', 'He ascended into heaven,')
    , newParagraph( 'indent', 'and is seated at the right hand of the Father.')
    , newParagraph( 'indent', 'He will come again to judge the living and the dead.')
    , newParagraph( 'no-indent', 'I believe in the Holy Spirit,')
    , newParagraph( 'indent', 'the holy catholic Church,')
    , newParagraph( 'indent', 'the communion of saints,')
    , newParagraph( 'indent', 'the forgiveness of sins,')
    , newParagraph( 'indent', 'the resurrection of the body,')
    , newParagraph( 'indent', 'and the life everlasting. Amen.')
  ]) 
  return node;
}

function lordsPrayer() {
  return newDiv('lordsPrayer', '').append( [tradLP(), contLP() ] );
}

function tradLP() {
  return newDiv('tradLordsPrayer', '').append([
      newParagraph('no-indent',  'Our Father, who art in heaven,')
    , newParagraph('indent',    'hallowed be thy Name,')
    , newParagraph('indent',    'Thy kingdom come,')
    , newParagraph('indent',    'thy will be done, ')
    , newParagraph('indent2',   'on earth as it is in heaven.')
    , newParagraph('no-indent',  'Give us this day our daily bread.')
    , newParagraph('no-indent',  'And forgive us our trespasses,')
    , newParagraph('indent',    'as we forgive those')
    , newParagraph('indent2',   'who trespass against us.')
    , newParagraph('no-indent',  'And lead us not into temptation,')
    , newParagraph('indent',    'but deliver us from evil.')
    , newParagraph('no-indent',  'For thine is the kingdom,')
    , newParagraph('indent',    'and the power, and the glory')
    , newParagraph('indent',    'for ever and ever. Amen.')
    ])
}

function contLP() {
  return newDiv('contLordsPrayer', '').append([
      newParagraph('no-indent',  'Our Father in heaven,')
    , newParagraph('indent',    'hallowed be your Name,')
    , newParagraph('indent',    'Your kingdom come,')
    , newParagraph('indent',    'your will be done,')
    , newParagraph('indent2',   'on earth as it is in heaven.')
    , newParagraph('no-indent',  'Give us today our daily bread.')
    , newParagraph('no-indent',  'And forgive us our sins')
    , newParagraph('indent',    'as we forgive those')
    , newParagraph('indent2',   'who sin against us.')
    , newParagraph('no-indent',  'Save us from the time of trial,')
    , newParagraph('indent',    'and deliver us from evil.')
    , newParagraph('no-indent',  'For the kingdom, the power,')
    , newParagraph('indent',    'and the glory are yours')
    , newParagraph('indent',    'now and for ever. Amen.')
    ])
}
// module.export { pageBuild };
 

 
 
 

 
 
 
 
 
 
