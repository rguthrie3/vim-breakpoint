A simple plugin for writing out breakpoints to a file to be read in by GDB.
The heavy-weight Vim GDB plugins can be a bit much, but I wanted an easier way to set breakpoints
instead of having to look at your text editor and type them in manually.
Just source the file that this plugin writes in GDB and you will be good to go.
The file will be deleted once Vim is closed so that it isn't always cluttering everything.
Writes to the file happen when a buffer is written.

