import { WebPlugin } from '@capacitor/core';

import type { VolumeEventReceiverPlugin } from './definitions';

export class VolumeEventReceiverWeb extends WebPlugin implements VolumeEventReceiverPlugin {
  async startListening(): Promise<{ status: string }> {
    return { status: 'Not implemented for web' };
  }

    async stopListening(): Promise<{ status: string }> {
        return { status: 'Not implemented for web' };
    }
}
