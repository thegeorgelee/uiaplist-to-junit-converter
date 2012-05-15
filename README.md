*IMPORTANT:* This is version 0.1 of the software.  Do not use in production systems yet!

## uiaplist-to-junit-converter

This program converts the UIAutomation Property List output into a jUnit XML file.  The output can then be fed into continuous integration programs such a Jenkins / Hudson as jUnit testsuites.


## Information

Just download, compile and copy the resulting binary to where you need it. Run with the following arguments (use full paths for now):

uia2junit <source_plist> <output_path>

uia2junit "/Users/<username>/Documents/auto/Run 1/Automation Results.plist" "/Users/<username>/Documents/auto/automation_results.xml"


### Requirements

This code has only been tested on:
* XCode 4.3+ 
* Lion 10.7+


### Bug reports

If you discover a problem with uiaplist-to-junit-converter, we would like to know about it. However, we ask that you please review the open issues for possible duplicates before submitting a new report:

https://github.com/thegeorgelee/uiaplist-to-junit-converter/issues

If you found a security bug, do *NOT* use the GitHub issue tracker. Send an email to the maintainers listed at the bottom of the README.


## Additional information

### Contributing

We hope that you will consider contributing to uiaplist-to-junit-converter. Please read this short overview for some information about how to get started:

https://github.com/thegeorgelee/uiaplist-to-junit-converter/wiki/Contributing

We have a list of valued contributors. Check them all at:

https://github.com/thegeorgelee/uiaplist-to-junit-converter/contributors


### Maintainers

* George Lee (https://github.com/thegeorgelee)


## License

New BSD License. Copyright (c) 2012 George Lee
