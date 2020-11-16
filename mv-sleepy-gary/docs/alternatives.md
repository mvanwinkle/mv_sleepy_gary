# Alternatives System

The installation and removal must be done by scripts.

## Documentation

* RPM
	* https://docs.fedoraproject.org/en-US/packaging-guidelines/Alternatives/
	* https://docs.fedoraproject.org/ro/Fedora_Draft_Documentation/0.1/html/RPM_Guide/ch09s04s05.html - Defining installation scripts

* Debian
	* https://wiki.debian.org/DebianAlternatives
	* https://www.debian.org/doc/debian-policy/ch-maintainerscripts.html)


## Installation

* For RPMs, put this in *RPM/install_scripts/post*.
* For debian packages, put this in *DEBIAN/postinst*

```
update-alternatives --install \
	/usr/bin/mv-sleepy-gary_hello \
	mv-sleepy-gary_hello \
	/opt/IAS/bin/mv-sleepy-gary/mv-sleepy-gary_hello.sh 50
```

* For RPMs, put this in *RPM/install_scripts/preun*
* For DEBs, put this in *DEBIAN/prerm*

```
update-alternatives --remove \
	mv-sleepy-gary_hello \
	/opt/IAS/bin/mv-sleepy-gary/mv-sleepy-gary_hello.sh
```
