# `man2pdf`

Convert manpages to PDF.

## Bash script

The bash script is the **[`src/bash/man2pdf.sh`](./src/bash/man2pdf.sh)** file.

### Install to `PATH`

You can add `man2pdf` to one of your `PATH` directories to make it directly invocable from the command line.

The repository's [`Makefile`](./Makefile) also provides you convenient operations:

* **`make install` / `make uninstall`: Install the `man2pdf` script _for the current user_.**
    * The `man2pdf` script will be placed in the **`/home/$USER/bin`** directory.
        * Please ensure that the directory `/home/$USER/bin` exists (_if not, you need to manually create it first_), and is included in the `PATH` environment variable.
    * Auxiliary scripts will be placed in the `/home/$USER/.local/share/man2pdf` directory.
* **`sudo make install` / `sudo make uninstall`: Install the `man2pdf` script _for all users_.**
    * The `man2pdf` script will be placed in the **`/usr/local/bin`** directory.
    * Auxiliary scripts will be placed in the `/usr/local/share/man2pdf` directory.

### Usage

```bash
man2pdf <man_page_name> [out_file.pdf]
```

* The `<man_page_name>` is the name of the manpage. It takes one of these forms:
    1. `<manpage_name>.<section>`
    2. `<manpage_name>(<section>)`
    3. `<manpage_name>` _(The section is resolved automatically)_
* The `[out_file.pdf]` argument is optional. If omitted, it will be resolved to the format `<manpage_name>(<section>).pdf`, and saved under the _current working directory_.