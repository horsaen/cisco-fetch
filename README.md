# cisco-fetch
An information tool for Cisco IOS (Catalyst 2960S)

This script was designed to work on Cisco Catalyst 2960S, as I have no other switch to test this on, YMMV on other switches.

## Setup

If your switch's `copy https://` doesn't throw a fit, simply enable then get the file:

```
copy https://raw.githubusercontent.com/horsaen/cisco-fetch/main/main.tcl cisco-fetch
```

Then:
```
tclsh cisco-fetch
```