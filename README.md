# FlacCueSplit

Split up CUE Sheets into multiple tracks.

## Dependencies

Uses [shnsplit](https://manpages.debian.org/testing/shntool/shnsplit.1.en.html) and [cuetag](http://manpages.org/cuetag).

Ubuntu: `sudo apt-get install shntool cuetools`

## Running Extraction

How to use start extraction:

`./flaccuesplit.sh path/to/directory/containing/cuesheet`

## Cases Handled

| Case                         | Action                                                      |
| ---------------------------- | ----------------------------------------------------------- |
| Single CUE / Single FLAC     | Process right away                                          |
| Single CUE / Multiple FLAC   | Not Supported if CUE Sheet has more than one FILE command   |
| Multiple CUE / Single FLAC   | Choose which CUE Sheet file to use                          |
| Multiple CUE / Multiple FLAC | Create a folder per CUE Sheet, run Single CUE / Single FLAC |

**Note**: For the Multiple CUE / Multiple FLAC case it will temporarily move the CUE and corresponding FLAC file to the new directory for processing. The files will be returned back to their original location upon completion.
