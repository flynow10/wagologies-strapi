import type { Core } from '@strapi/strapi';
import { shutdownServer } from '../utils/shutdown';

const shutdown = ({ strapi }: { strapi: Core.Strapi }) => ({
  async index(ctx) {
    const output = await shutdownServer();
    if (output === true) {
      ctx.body = {
        success: true,
      };
    } else {
      ctx.body = {
        error: output,
      };
    }
  },
});

export default shutdown;
