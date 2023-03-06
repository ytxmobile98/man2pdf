import assert from "node:assert";
import { spawnSync } from "node:child_process";
import { describe, it } from "node:test";

describe('Check prerequisites', () => {
    function which(arg: string): boolean {
        const spawnedProcess = spawnSync('which', [ arg ], {
            stdio: 'ignore'
        });
        return spawnedProcess.status === 0;
    }

    for (const prerequisite of [
        'man',
        'ps2pdf'
    ]) {
        it(`"${prerequisite}" should exist`, () => {
            assert.ok(which(prerequisite));
        });
    }
});