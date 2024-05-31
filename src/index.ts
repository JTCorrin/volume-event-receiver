import { registerPlugin } from '@capacitor/core';

import type { VolumeEventReceiverPlugin } from './definitions';

const VolumeEventReceiver = registerPlugin<VolumeEventReceiverPlugin>('VolumeEventReceiver', {
  web: () => import('./web').then(m => new m.VolumeEventReceiverWeb()),
});

export * from './definitions';
export { VolumeEventReceiver };
