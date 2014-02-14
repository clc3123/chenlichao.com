---
layout: post
title: iframe
description: iframe
---

http://stackoverflow.com/questions/251420/invoking-javascript-in-iframe-from-parent-page

There are some quirks to be aware of here.

HTMLIFrameElement.contentWindow is probably the easier way, but it's not quite a standard property and some browsers don't support it, mostly older ones. This is because the DOM Level 1 HTML standard has nothing to say about the window object.

You can also try HTMLIFrameElement.contentDocument.defaultView, which a couple of older browsers allow but IE doesn't. Even so, the standard doesn't explicitly say that you get the window object back, for the same reason as (1), but you can pick up a few extra browser versions here if you care.

window.frames['name'] returning the window is the oldest and hence most reliable interface. But you then have to use a name="..." attribute to be able to get a frame by name, which is slightly ugly/deprecated/transitional. (id="..." would be better but IE doesn't like that.)

window.frames[number] is also very reliable, but knowing the right index is the trick. You can get away with this eg. if you know you only have the one iframe on the page.

It is entirely possible the child iframe hasn't loaded yet, or something else went wrong to make it inaccessible. You may find it easier to reverse the flow of communications: that is, have the child iframe notify its window.parent script when it has finished loaded and is ready to be called back. By passing one of its own objects (eg. a callback function) to the parent script, that parent can then communicate directly with the script in the iframe without having to worry about what HTMLIFrameElement it is associated with.

<iframe src="test.html" name="banner" width="300" marginwidth="0" height="300" marginheight="0" align="top" scrolling="No" frameborder="0" hspace="0" vspace="0">Browser not compatible. </iframe>

Here's a list of alternatives:

Javascript options:

window.top.location.href=theLocation;
window.parent.location.href=theLocation;
window.top.location.replace(theLocation);
Non-javascript options:

<a href="theLocation" target="_top">Click here to continue</a>  
<a href="theLocation" target="_parent">Click here to continue</a>

iframe_element.src = "about:blank"

about:blank
is a "URL" that is blank. It's always clear

You can set the page's source to that, and it will clear.


## http://stackoverflow.com/questions/369498/how-to-prevent-iframe-from-redirecting-top-level-window
With HTML5 the iframe sandbox attribute was added. At the time of writing this works only on Chrome and Safari but does pretty much what you want:

<iframe src="url" sandbox="allow-forms allow-scripts"></iframe>
If you want to allow top-level redirects specify sandbox="allow-top-navigation".

I know it has been a long time since question was done but here is my improved version it will wait 500ms for any subsequent call only when the iframe is loaded.

<script type="text/javasript">
var prevent_bust = false ;
    var from_loading_204 = false;
    var frame_loading = false;
    var prevent_bust_timer = 0;
    var  primer = true;
    window.onbeforeunload = function(event) {
        prevent_bust = !from_loading_204 && frame_loading;
        if(from_loading_204)from_loading_204 = false;
        if(prevent_bust){
            prevent_bust_timer=500;
        }
    }
    function frameLoad(){
        if(!primer){
            from_loading_204 = true;
            window.top.location = '/?204';
            prevent_bust = false;
            frame_loading = true;
            prevent_bust_timer=1000;
        }else{
            primer = false;
        }
    }
    setInterval(function() {  
        if (prevent_bust_timer>0) {  
            if(prevent_bust){
                from_loading_204 = true;
                window.top.location = '/?204';
                prevent_bust = false;
            }else if(prevent_bust_timer == 1){
                frame_loading = false;
                prevent_bust = false;
                from_loading_204 = false;
                prevent_bust_timer == 0;
            }



        }
        prevent_bust_timer--;
        if(prevent_bust_timer==-100) {
            prevent_bust_timer = 0;
        }
    }, 1);
</script>
and onload="frameLoad()" and onreadystatechange="frameLoad();" must be added to the frame or iframe.

## http://stackoverflow.com/questions/580669/redirect-parent-window-from-an-iframe-action-using-javascript

window.top.location.href = "http://www.site.com"; 
As stated previously, will redirect the parent iframe. One thing to bear in mind is that both the website, and the site contained in the iframe need to be on the same domain for this to work, or you'll get an access denied exception.

So, if the site is 'www.site.com', and the iframe is 'iframe.site.com', in both pages you'll need to put:

document.domain = "site.com"
