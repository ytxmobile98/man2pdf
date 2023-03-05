import { spawnSync, SpawnSyncReturns } from 'node:child_process';
import path from 'node:path';

const MAN2PDF_EXEC = path.resolve(
    __dirname, // the <repo_root>/dist/js directory
    '../bash', // the <repo_root>/dist/bash directory
    'man2pdf.sh'
);

export function man2pdf(manpage: string, outPath: string = ''): SpawnSyncReturns<Buffer> {
    const args: string[] = [ manpage ];
    if (outPath) {
        args.push(outPath);
    }

    const ret = spawnSync(MAN2PDF_EXEC, args, {
        stdio: 'inherit'
    });
    return ret;
}

export default man2pdf;