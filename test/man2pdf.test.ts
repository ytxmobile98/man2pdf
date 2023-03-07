import assert from "node:assert";
import { existsSync, mkdtempSync, rmSync } from 'node:fs';
import { join } from "node:path";

import man2pdf from '../src/ts';

describe('man2pdf tests', () => {
    it('nonexistent manpage', () => {
        const spawnResult = man2pdf('.');
        assert.ok(spawnResult.status !== 0, spawnResult.error?.message);
    });

    describe('generate .pdf files in current working directory', () => {
        const CWD = process.cwd();

        function runTest(manpage: string, expectedFilename: string) {
            const expectedFilePath = join(CWD, expectedFilename);

            const spawnResult = man2pdf(manpage);
            assert.ok(spawnResult.status === 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
            rmSync(expectedFilePath);
        }

        it('manpage_name, no section', () => {
            runTest('ls', 'ls(1).pdf');
        });

        it('manpage_name.section', () => {
            runTest('ls.1', 'ls(1).pdf');
        });

        it('manpage_name(section)', () => {
            runTest('ls(1)', 'ls(1).pdf');
        });
    });

    describe('generate .pdf files in temporary directory', () => {
        let tempDir: string = '';

        beforeEach(() => {
            tempDir = mkdtempSync('/tmp/');
        });

        afterEach(() => {
            rmSync(tempDir, { recursive: true });
        });

        function runTest(manpage: string, expectedFilename: string) {
            const expectedFilePath = join(tempDir, expectedFilename);

            const spawnResult = man2pdf(manpage, tempDir);
            assert.ok(spawnResult.status === 0, spawnResult.error?.message);

            assert.ok(existsSync(expectedFilePath));
            rmSync(expectedFilePath);
        }

        it('manpage_name, no section', () => {
            runTest('ls', 'ls(1).pdf');
        });

        it('manpage_name.section', () => {
            runTest('ls.1', 'ls(1).pdf');
        });

        it('manpage_name(section)', () => {
            runTest('ls(1)', 'ls(1).pdf');
        });
    });
});