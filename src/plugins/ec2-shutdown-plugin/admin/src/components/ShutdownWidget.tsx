import { Button, Flex } from '@strapi/design-system';
import { WarningCircle } from '@strapi/icons';
import { useFetchClient, useNotification } from '@strapi/strapi/admin';
import { useState } from 'react';
import { PLUGIN_ID } from '../pluginId';
import { useIntl } from 'react-intl';

const ShutdownWidget: React.FC = () => {
  const [isShuttingDown, setIsShuttingDown] = useState(false);
  const { get } = useFetchClient();
  const { toggleNotification } = useNotification();
  const { formatMessage } = useIntl();

  const handleShutdown = async () => {
    if (confirm('Are you sure you want to shut down the admin panel?')) {
      setIsShuttingDown(true);
      const { data } = await get('/ec2-shutdown-plugin/shutdown');

      if (data?.error) {
        toggleNotification({
          type: 'danger',
          title: formatMessage({
            id: `${PLUGIN_ID}.shutdown.notification.failure`,
          }),
          message: data.error,
        });
        setIsShuttingDown(false);
        return;
      }

      console.log(data);

      toggleNotification({
        type: 'success',
        title: formatMessage({
          id: `${PLUGIN_ID}.shutdown.notification.success`,
        }),
      });
    }
  };

  const Icon = isShuttingDown ? null : <WarningCircle />;

  return (
    <Flex alignItems={'center'} justifyContent={'center'} height={'100%'}>
      <Button
        variant="danger"
        startIcon={Icon}
        loading={isShuttingDown}
        size="L"
        onClick={handleShutdown}
        type="button"
      >
        Shutdown
      </Button>
    </Flex>
  );
};

export default ShutdownWidget;
