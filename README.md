# mv_sleepy_gary

This is (was?) intended to be a way of rate-limiting certain blocks of code
for testing things like email throttling.  Along the process of getting what
I needed out of it, it wasn't "completed" or "fully tested", and it leaves
much to be desired; but it served its purpose and might deserve
to be preserved.

# License

copyright (C) 2020 Martin VanWinkle, Institution

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

See 

* http://www.gnu.org/licenses/

## Description

SleepyGary is named after an alien parasite that spreads itself by infecting
the memories of hosts.

SleepyGary will (by default) not sleep until failure() is caused.  It then does
an exponetial backoff until a success().  It calculates how many successes there
were from the first success() to the first success() after the last failure().

It comes up with an approximate rate for which to maximize successes.

It will then either lower the rate or raise the rate depending on if failure()
or success() is called.

### Use

Before the code block you call ```$gary->wait()```.

When you weren't throttled, i.e. you were able to do things succesfully, you call ```$gary->success()```

If you were throttled, you call ```$gary->failure()```.

Supplemental documentation for this project can be found here:

* [Supplemental Documentation](./doc/index.md)

### Testing

No, this hasn't been fully tested.

# Installation

Ideally stuff should run if you clone the git repo, and install the deps specified
in either "DEBIAN/control" or "RPM/specfile.spec"

Optionally, you can build a package which will install the binaries in

* /opt/IAS/bin/mv-sleepy-gary/

# Building a Package

## Requirements

### All Systems

* fakeroot

### Debian

* build-essential

### RHEL based systems

* rpm-build

## Export a specific tag (or just the project directory)

## Supported Systems

### Debian packages

```
  fakeroot make package-deb
```

### RHEL Based Systems

```
fakeroot make package-rpm
```

