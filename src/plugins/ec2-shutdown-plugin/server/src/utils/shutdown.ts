import { exec } from 'child_process';

export async function shutdownServer(): Promise<true | string> {
  try {
    if (process.env.NODE_ENV === 'production') {
      await new Promise((res, rej) =>
        exec('shutdown -h now', (err, stdout, stderr) => {
          if (err) {
            rej(stderr);
          }
          res(stdout);
        })
      );
    } else {
      console.log('Shutdown issued, no action performed in development');
    }
    return true;
  } catch (e) {
    return e;
  }
}
