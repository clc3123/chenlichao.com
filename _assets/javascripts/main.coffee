generateToc = ->
  headings = $('.post-content [id^="toc_"]')
  roots = []
  appendToRoot = (level, item) ->
    return if item.data('appended')
    roots[level] = item if level < 6
    root = (roots[level - 1] ?= $('<li>').html('<a href="#">undefined</a>')) 
    appendPoint = if root.children('ol').length then root.children('ol') else $('<ol>').appendTo(root)
    appendPoint.append item
    item.data('appended', true)
    appendToRoot level - 1, root unless level - 1 == 0

  for h in headings
    [hLevel, hId, hContent] = [h.tagName.charAt(1) * 1, h.id, h.innerHTML]
    hItem = $('<li>').html('<a href="#' + hId + '">' + hContent + '</a>')
    n = hLevel + 1
    while n < 6
      roots[n] = undefined
      n++
    appendToRoot hLevel, hItem

  toc = roots[0].find('ol:first').find('ol:first').addClass('toc')
  toc.prependTo('.post-content')

addCodeLinenos = ->
  $('.highlight code').html (i, html) -> 
    lines = html.split("\n")
    lines.shift() while /^\s*$/.test lines[0]
    lines.pop() while /^\s*$/.test lines[lines.length - 1]
    ('<span class="line"><span class="content">' + l + '</span></span>' for l in lines).join("\n")

consoleChao = ->
  console = (window.console ?= {})
  if not console.log then console.log = ->
  console.log """
  %c
  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMXOkkOXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMd    dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMl    lMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMl    lMMMMMMMMMMMMMMMk,;;::cclooxkkkOO00KXXNMMMMM
  MMMMMO::;::::;;.    .,;;;::::coKMMMX;                .....'c0MMM
  MMMMMl                        .xMMMNxc::;.                 .kMMM
  MMMMMx........        ........:0MMMMMMMMX:    :00OOkkkc.   .kMMM
  MMMMMWNXXXK000x.    .x000KXXXXWMMMMMMMMWo    .OMMMMMMMk.   .kMMM
  MMMMMMMMMMMMMMK,    ,KMMMMMMMMMMMMMMMMMO.    oWMMMMMMMk.   .kMMM
  MMMMMMMMMMMMMMN:    cWMMMMMMMMMMMMMMMMN:    ,KMMMMMMMMx.   .OMMM
  MMN0OOOOOOOOOOO;    ;OOOOOOO00000KNMMWd.   .xMMMMMMMMMd    ,0MMM
  MMx.                         .....xMM0'    :XMMMMMMMMMd    ,KMMM
  MMx.                              dMWl    '0MMMMMN0OOk:    ;XMMM
  MMN0kkkxooooool'    .coooooodkkkkOXMXc.  .xMMMMMMO'        lMMMM
  MMMMMMMMMMMMMMMl    ,0MMMMMMMMMMMMMMMNKkokWMMMMMMNxc::;::::OMMMM
  MMMMMMMMMMMMMMMl    .kXXXNMMMMMMMMMMMMMWNXXXXXXXXXXXXNMMMMMMMMMM
  MMMMMMMMMMMMMMMl     ....',;;dXMMMM0c,;,.............',,;oKMMMMM
  MMMMMM0xOKNMMMMo             :NMMMMx.                    .kMMMMM
  MMMMM0,  .:KMMMd    .cxooooll0MMMMMd    .ckkkkkkkkkk,    .kMMMMM
  MMMMWl    :NMMMx.   .kMMMMMMMMMMMMMd    .kMMMMMMMMMMl    .kMMMMM
  MMMMk.   .OMMMMO,...,OMMMMMMMMMMMMMd    .kMMMMMMMMMMl    .kMMMMM
  MMMN:    lWMMMMWX000XWMMMMMMMMMMMMMd.   .kMMMMMMMMMMl    .kMMMMM
  MMMx.   .l0KNWMMMMMMMMMMMMMMMMMMMMMk.    ,cccccccccc.    .kMMMMM
  MMX:       ..,;:loxkO0XWMMMMMMMMMMMk.                    .OMMMMM
  MMKo;'.              ..';::lox0WMMMXOdoolccccccc::::cccccxNMMMMM
  MMMMMNK0Odoc:;'..             lWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMWX0Okxdlc:;;'..'OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMMMMMMMMMMMMWXKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
  """, "color: white; background: #312743"

$ ->
  if window.location.pathname.match(/^\/(articles|notes)\//)
    generateToc()
    addCodeLinenos()

  consoleChao()
