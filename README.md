# `man2pdf`

Convert manpages to PDF.

## Bash script

The bash script is the **[`src/bash/man2pdf.sh`](./src/bash/man2pdf.sh)** file.

### Install to `PATH`

You can add `man2pdf` to one of your `PATH` directories to make it directly invocable from the command line.

The repository's [`Makefile`](./Makefile) also provides you convenient operations:

* `make install` / `make uninstall`: Install the `man2pdf` script _for the current user_.
    * The `man2pdf` script will be placed in the **`/home/$USER/bin`** directory.
        * Please ensure that the directory `/home/$USER/bin` exists (_if not, you need to manually create it first_), and is included in the `PATH` environment variable.
    * Auxiliary scripts will be placed in the `/home/$USER/.local/share/man2pdf` directory.
* `sudo make install` / `sudo make uninstall`: Install the `man2pdf` script _for all users_.
    * The `man2pdf` script will be placed in the **`/usr/local/bin`** directory.
    * Auxiliary scripts will be placed in the `/usr/local/share/man2pdf` directory.