import { WebPlugin } from '@capacitor/core';

import type { VolumeEventReceiverPlugin } from './definitions';

export class VolumeEventReceiverWeb extends WebPlugin implements VolumeEventReceiverPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
