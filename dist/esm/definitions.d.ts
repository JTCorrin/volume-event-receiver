export interface VolumeEventReceiverPlugin {
    startListening(): Promise<{
        status: string;
    }>;
    stopListening(): Promise<{
        status: string;
    }>;
}
