Stry
====

A web application for writing media rich movie and game scripts.

I'm scratching my own itch with Stry. I am working on a game that is cinematic, so it has a script very similar to a
movie script. The problem is that there are no tools that really do what I need. Stry is that tool:

* Stories have scenes, and scenes are made of blocks, which are chunks of text coded as a certain type (eg. Playable, or
  Scripted Sequence)
* Blocks can have attachments so it's possible to storyboard scenes or include reference material inline
* The interface is meant to be extremely intuitive, like working in a word processing document. If you can see it, you
  can edit it. You can add new scenes, blocks, and attachments seamlessly, and sort any of them by simply dragging and
  dropping.
* This has only been tested in Chrome on Mac OS X, and uses a lot of JavaScript, HTML5, and CSS3, which means it's
  likely broken in other browsers.

TODO
====

* Better Attachment handling. Right now it assumes everything is an image, but I want to support other file types
  cleanly as well
* Cross Browser Testing
* Unit Test Suite
