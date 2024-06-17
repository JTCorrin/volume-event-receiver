import { WebPlugin } from '@capacitor/core';
import type { VolumeEventReceiverPlugin } from './definitions';
export declare class VolumeEventReceiverWeb extends WebPlugin implements VolumeEventReceiverPlugin {
    startListening(): Promise<{
        status: string;
    }>;
    stopListening(): Promise<{
        status: string;
    }>;
}
