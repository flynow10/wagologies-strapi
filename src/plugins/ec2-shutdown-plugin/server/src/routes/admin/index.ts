export default () => ({
  type: 'admin',
  routes: [
    {
      method: 'GET',
      path: '/shutdown',
      handler: 'shutdown.index',
      config: {
        auth: {
          scope: ['plugin::ec2-shutdown-plugin.shutdown'],
        },
      },
    },
  ],
});
