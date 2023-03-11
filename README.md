# `man2pdf`

Convert manpages to PDF.

## NPM package

### Install

```bash
npm install man2pdf
```

### Usage

See the [`examples/js_ts`](./examples/js_ts/) directory for usage.

There are three files:

* JavaScript version (CommonJS): [`man.js`](./examples/js_ts/man.js)
* JavaScript version (ESModule): [`man.mjs`](./examples/js_ts/man.mjs)
* TypeScript version: [`man.ts`](./examples/js_ts/man.ts)

## Bash script

The bash script is the **[`src/bash/man2pdf.sh`](./src/bash/man2pdf.sh)** file, for which the NPM script depends on.

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
man2pdf <manpage> [/path/to/out_file.pdf]
```

* **The `<manpage>` is the name (_or possibly the name and the section number_, separated by a space character) of the manpage**. It takes one of these forms:
    1. `<manpage_name>` (_The section is resolved automatically_)
    2. `"<section> <manpage_name>"` (_with a space in-between_, so must surrounded by quotation marks)
* The `[/path/to/out_file.pdf]` argument is optional.
    * If omitted, it will be resolved to the format `<manpage_name>(<section>).pdf`, and saved under the _current working directory_.
    * If it is specified as an existing directory, the filename will also be resolved to the format `<manpage_name>(<section>).pdf`, and saved under that directory.