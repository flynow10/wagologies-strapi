import type { Core } from '@strapi/strapi';

const bootstrap = ({ strapi }: { strapi: Core.Strapi }) => {
  const actions = [
    {
      section: 'plugins',
      displayName: 'Shutdown the EC2 Instance',
      uid: `shutdown`,
      pluginName: 'ec2-shutdown-plugin',
    },
  ];
  strapi.admin.services.permission.actionProvider.registerMany(actions);
};

export default bootstrap;
