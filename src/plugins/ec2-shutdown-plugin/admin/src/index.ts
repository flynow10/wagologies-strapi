import type { StrapiApp } from '@strapi/strapi/admin';
import { getTranslation } from './utils/getTranslation';
import { PLUGIN_ID } from './pluginId';
import { Initializer } from './components/Initializer';
import { Lightbulb } from '@strapi/icons';

const plugin: StrapiApp['appPlugins'][string] = {
  register(app) {
    app.registerPlugin({
      id: PLUGIN_ID,
      initializer: Initializer,
      isReady: false,
      name: PLUGIN_ID,
    });

    app.widgets.register({
      icon: Lightbulb,
      title: {
        id: `${PLUGIN_ID}.widget.name`,
      },
      id: 'ec2-shutdown-widget',
      component: async () => {
        const component = await import('./components/ShutdownWidget');
        return component.default;
      },
      permissions: [
        {
          action: `plugin::${PLUGIN_ID}.shutdown`,
        },
      ],
      pluginId: PLUGIN_ID,
    });
  },
  bootstrap() {},

  registerTrads({ locales }) {
    return Promise.all(
      locales.map(async (locale) => {
        try {
          const { default: data } = (await import(`./translations/${locale}.json`)) as {
            default: Record<string, string>;
          };

          const newData: Record<string, string> = {};
          const keys = Object.keys(data);

          for (const key of keys) {
            newData[getTranslation(key)] = data[key];
          }

          return { data: newData, locale };
        } catch {
          return { data: {}, locale };
        }
      })
    );
  },
};

export default plugin;
