export interface VolumeEventReceiverPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
