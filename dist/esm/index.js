import { registerPlugin } from '@capacitor/core';
const VolumeEventReceiver = registerPlugin('VolumeEventReceiver', {
    web: () => import('./web').then(m => new m.VolumeEventReceiverWeb()),
});
export * from './definitions';
export { VolumeEventReceiver };
//# sourceMappingURL=index.js.map