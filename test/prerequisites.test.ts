import assert from "node:assert";
import { spawnSync } from "node:child_process";

describe('Check prerequisites', () => {
    function commandIsAvailable(arg: string): boolean {
        const spawnedProcess = spawnSync('which', [ arg ], {
            stdio: 'ignore'
        });
        return spawnedProcess.status === 0;
    }

    const prerequisites = [ 'man', 'ps2pdf' ];

    for (const prerequisite of prerequisites) {
        it(`"${prerequisite}" should exist`, () => {
            assert.ok(commandIsAvailable(prerequisite), `Command "${prerequisite}" does not exist`);
        });
    }
});