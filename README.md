# General Information

## Maintainer
Jonas Purtschert [jonas.purtschert@psi.ch]

## Contributors
* Oliver Bründler [oli.bruendler@gmx.ch]
* Jonas Purtschert [jonas.purtschert@psi.ch]
* Reto Meier [reto.meier@dectris.com]
* Patrick Studer [studer.patrick92@gmail.com]

## License
This library is published under [PSI HDL Library License](License.txt), which is [LGPL](LGPL2_1.txt) plus some additional exceptions to clarify the LGPL terms in the context of firmware development.

## Documentation
See [Documentation](./doc/Index.md)

## Changelog
See [Changelog](Changelog.md)

## Tagging Policy
Stable releases are tagged in the form *major*.*minor*.*bugfix*. 

* Whenever a change is not fully backward compatible, the *major* version number is incremented
* Whenever new features are added, the *minor* version number is incremented
* If only bugs are fixed (i.e. no functional changes are applied), the *bugfix* version is incremented

# Dependencies
Currently none

# Usage
This TCL framework allows to easily package Vivado IP-Cores from tcl scripts. This has many advantages in terms of 
less interactive (and error-prone) packaging, reproducibility and maintainabilit (scripts can easily be version controlled).

## Notes
The framework is written with portability to newer vivado versions in mind. By default, the latest version of Vivado
should be used but it is possible to run the framework for any specific older version of Vivado at any time.
