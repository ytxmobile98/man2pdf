import assert from "node:assert";
import { existsSync, rmSync } from 'node:fs';
import { join } from "node:path";

import man2pdf from '../src/ts';

describe('man2pdf tests', () => {
    const CWD = process.cwd();

    it('nonexistent manpage', () => {
        const spawnResult = man2pdf('.');
        assert.ok(spawnResult.status !== 0, spawnResult.error?.message);
    });

    it('manpage_name, no section', () => {
        const EXPECTED_FILENAME = 'ls(1).pdf';
        const EXPECTED_FILE_PATH = join(CWD, EXPECTED_FILENAME);

        const spawnResult = man2pdf('ls');
        assert.ok(spawnResult.status === 0, spawnResult.error?.message);

        assert.ok(existsSync(EXPECTED_FILE_PATH));
        rmSync(EXPECTED_FILE_PATH);
    });

    it('manpage_name.section', () => {
        const EXPECTED_FILENAME = 'ls(1).pdf';
        const EXPECTED_FILE_PATH = join(CWD, EXPECTED_FILENAME);

        const spawnResult = man2pdf('ls.1');
        assert.ok(spawnResult.status === 0, spawnResult.error?.message);

        assert.ok(existsSync(EXPECTED_FILE_PATH));
        rmSync(EXPECTED_FILE_PATH);
    });

    it('manpage_name(section)', () => {
        const EXPECTED_FILENAME = 'ls(1).pdf';
        const EXPECTED_FILE_PATH = join(CWD, EXPECTED_FILENAME);

        const spawnResult = man2pdf('ls(1)');
        assert.ok(spawnResult.status === 0, spawnResult.error?.message);

        assert.ok(existsSync(EXPECTED_FILE_PATH));
        rmSync(EXPECTED_FILE_PATH);
    });
});