<h3>Description</h3>
As mentioned in my blog article: <a href="http://private-storm.de/2011/04/23/guids-identify-file/">guids-identify-file</a> you don't need to specify a filepath / filename to identify a file.

I don't know if that might be useful for you but I've created a small demo based on an article of <a href="http://blogs.msdn.com/b/oldnewthing/archive/2011/02/28/10134679.aspx">Raymond Chen</a> converted to Delphi.

<h3>Example Usage</h3>

* Compile the demo (debug mode)
* Click the File... button and choose a file from your haddrive (don't click the "Open file by Guid" button yet!)

Let's assume you've choosen the following file:

    "D:\Test\Blubb\Test.exe"

Cut out the Test.exe and move it to this path:

    "D:\Test\Test.exe"

* Time for pressing the "Open file by Guid" button.

If everything works correctly a line will be added to the memo (magically since you moved the executeable from the original location but its still found!)

<h3>Attention</h3>

> The only exception I've found is that you can't move the file to another partition, that will not work. Which is correctly the function needs a start partition to be set.