fintp_utils
===========

Utils library for **FinTP**

Requirements
------------
- Boost
- Xerces-C
- pthread

Build instructions
------------------
- On Unix-like systems, **fintp_utils** uses the GNU Build System (Autotools) so we first need to generate the configuration script using:


        autoreconf -fi
Now we must run: 

        ./configure
        make

- For Windows, a Visual Studio 2010 solution is provided.

License
-------
- [GPLv3](http://www.gnu.org/licenses/gpl-3.0.html)
