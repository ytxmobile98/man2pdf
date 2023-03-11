const { rmSync } = require('fs');
const { resolve } = require('path');

const man2pdf = require('man2pdf');

process.chdir(__dirname);

{
    // create PDF, no section names
    man2pdf('man'); // creates man(1).pdf
    man2pdf('man', 'man.pdf'); // creates man.pdf
    man2pdf('man', '../out'); // creates ../out/man(1).pdf

    // clean up
    for (const pdfPath of [
        'man(1).pdf',
        'man.pdf',
        '../out/man(1).pdf'
    ]) {
        rmSync(pdfPath);
        console.log('Removed:', resolve(pdfPath));
    }
}

{
    // create PDF, with section names
    man2pdf('1 man'); // creates man(1).pdf
    man2pdf('1 man', 'man.pdf'); // creates man.pdf
    man2pdf('1 man', '../out'); // creates ../out/man(1).pdf

    // clean up
    for (const pdfPath of [
        'man(1).pdf',
        'man.pdf',
        '../out/man(1).pdf'
    ]) {
        rmSync(pdfPath);
        console.log('Removed:', resolve(pdfPath));
    }
}