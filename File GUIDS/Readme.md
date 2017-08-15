<h3>Description</h3>
As already mentioned in my blog article <a href="http://private-storm.de/2011/04/23/guids-identify-file/">Using Guids to indentify a file</a> you don't need always a qualified path / filename to open a file.

Not sure if its useful at all but I've created a demo to show how it works.

<h3>Example</h3>


* Compile the demo (debug mode)
* Click the file button and chose an executeable <b>(don't click the "Open file by Guid button" yet.)</b>

You've choosen for example:

    D:\Test\Blubb\Test.exe

and generated the Object Identifier, which will be shown in a label below the filename.

* Now cut out the Test.exe from the above example path and place it e.g. here:

    D:\test.exe

* Time for pressing the <b>Open file by Guid button</b> if everything works correctly you will see that
inside the memo a line will be added (thats the magic, even while the file moved to another place.)

<h3>Important</h3>
>The only exception to this is, the file must stay on the same partionen from what I've tested.