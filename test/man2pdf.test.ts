import assert from "node:assert";
import { chmodSync, closeSync, existsSync, mkdtempSync, openSync, rmSync, statSync } from 'node:fs';
import { join } from "node:path";

import man2pdf from '../src/ts';

function createFile(filePath: string) {
    const fd = openSync(filePath, 'w');
    closeSync(fd);
}

function createReadOnlyFile(filePath: string) {
    createFile(filePath);
    chmodSync(filePath, 0o400);
}

describe('man2pdf tests', () => {
    it('nonexistent manpage', () => {
        const spawnResult = man2pdf('.');
        assert.notStrictEqual(spawnResult.status, 0, spawnResult.error?.message);
    });

    describe('generate .pdf files in current working directory', () => {
        const CWD = process.cwd();

        function runTest(manpage: string, expectedFilename: string) {
            const expectedFilePath = join(CWD, expectedFilename);

            const spawnResult = man2pdf(manpage);
            assert.strictEqual(spawnResult.status, 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
            rmSync(expectedFilePath);
        }

        it('manpage_name, no section', () => {
            runTest('man', 'man(1).pdf');
        });

        it('manpage_name, with section', () => {
            runTest('1 man', 'man(1).pdf');
        });
    });

    describe('generate .pdf files in temporary directory', () => {
        let tempDir: string = '';

        function runTest(manpage: string, expectedFilename: string) {
            const expectedFilePath = join(tempDir, expectedFilename);

            const spawnResult = man2pdf(manpage, tempDir);
            assert.strictEqual(spawnResult.status, 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
            rmSync(expectedFilePath);
        }

        beforeEach(() => {
            tempDir = mkdtempSync('/tmp/');
        });

        afterEach(() => {
            rmSync(tempDir, { recursive: true });
        });

        it('manpage_name, no section', () => {
            runTest('man', 'man(1).pdf');
        });

        it('manpage_name, with section', () => {
            runTest('1 man', 'man(1).pdf');
        });
    });

    describe('generate .pdf files in temporary directory (overwrite target file)', () => {
        let tempDir: string = '';
        const expectedFilename = 'man';
        let expectedFilePath: string = '';

        function runTest(manpage: string) {
            const spawnResult = man2pdf(manpage, expectedFilePath);
            assert.strictEqual(spawnResult.status, 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
        }

        beforeEach(() => {
            tempDir = mkdtempSync('/tmp/');
            expectedFilePath = join(tempDir, expectedFilename);

            createFile(expectedFilePath);
        });

        afterEach(() => {
            rmSync(tempDir, { recursive: true });
        });

        it('manpage_name, no section', () => {
            runTest('man');
        });

        it('manpage_name, with section', () => {
            runTest('1 man');
        });
    });

    describe('generate .pdf files in temporary directory (fail to overwrite read-only file)', () => {
        let tempDir: string = '';
        const expectedFilename = 'man';
        let expectedFilePath: string = '';

        function runTest(manpage: string) {
            assert.ok(existsSync(expectedFilePath));
            const statBefore = statSync(expectedFilePath);

            const spawnResult = man2pdf(manpage, expectedFilePath);
            assert.notStrictEqual(spawnResult.status, 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
            const statAfter = statSync(expectedFilePath);

            assert.deepStrictEqual(statBefore, statAfter,
                `The file "${expectedFilePath}" should be read-only and not modified.`);
        }

        beforeEach(() => {
            tempDir = mkdtempSync('/tmp/');
            expectedFilePath = join(tempDir, expectedFilename);

            createReadOnlyFile(expectedFilePath);
        });

        afterEach(() => {
            rmSync(tempDir, { recursive: true });
        });

        it('manpage_name, no section', () => {
            runTest('man');
        });

        it('manpage_name, with section', () => {
            runTest('1 man');
        });
    });
});