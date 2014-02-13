$ ->
  # $('.highlight').each ->
  #   container = $(@)
  #   count= container.find('code').text().split("\n").length - 1
  #   $('<table><tbody><tr><td class="linenos"></td><td class="lines"></td></tr></tbody></table>').appendTo(container)
  #   linenosTd = container.find '.linenos'
  #   linesTd = container.find '.lines'
  #   for nr in [1..count]
  #     linenosTd.append $('<div class="lineno">' + nr + '</div>')
  #   container.find('pre').appendTo(linesTd)
  $('.highlight code').html (i, html) -> 
    lines = html.split("\n")
    ('<span class="line"><span class="content">' + l + '</span></span>' for l in lines when l).join("\n")

( ->
    noop = ->
    methods = [
        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
        'timeStamp', 'trace', 'warn'
    ]
    console = (window.console ?= {})

    for method in methods
      if not console[method] then console[method] = noop
)()

# if window.devicePixelRatio
#   e = $('<div id="data">')
#   e.append $('<div>').text(window.devicePixelRatio)
#   e.append $('<div>').text(window.screen.width)
#   e.append $('<div>').text(window.innerWidth)
#   e.appendTo($('body'))

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
