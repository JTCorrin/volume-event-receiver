package com.corrindata.volumeeventreceiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

public class VolumeEventReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d("VolumeButtonReceiver", "Received intent");
        if ("android.media.VOLUME_CHANGED_ACTION".equals(intent.getAction())) {
            Log.d("VolumeButtonReceiver", "Volume button pressed");
        }
    }
    
    // Method to register the receiver
    public void registerReceiver(Context context) {
        IntentFilter filter = new IntentFilter("android.media.VOLUME_CHANGED_ACTION");
        Log.d("VolumeButtonReceiver", "Registering receiver");
        context.registerReceiver(this, filter);
    }
    
    // Method to unregister the receiver
    public void unregisterReceiver(Context context) {
        context.unregisterReceiver(this);
    }
}
