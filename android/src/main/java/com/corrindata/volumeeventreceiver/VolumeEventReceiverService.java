package com.corrindata.volumeeventreceiver;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.IBinder;
import androidx.core.app.NotificationCompat;
import android.util.Log;

public class VolumeEventReceiverService extends Service {
    private VolumeEventReceiver volumeEventReceiver;

    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize the VolumeEventReceiver
        volumeEventReceiver = new VolumeEventReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                super.onReceive(context, intent);
                // Notify the plugin about the volume event
                VolumeEventReceiverPlugin plugin = VolumeEventReceiverPlugin.getInstance();
                if (plugin != null) {
                    plugin.notifyVolumeEvent();
                }
            }
        };
        
        // Register the VolumeEventReceiver to listen for volume button presses
        volumeEventReceiver.registerReceiver(this);

        // Create the NotificationChannel
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                    "VolumeButtonServiceChannel",
                    "Volume Button Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }

        Notification notification = new NotificationCompat.Builder(this, "VolumeButtonServiceChannel")
                .setContentTitle("Volume Button Service")
                .setContentText("Listening for volume button presses. Phone must be UNLOCKED to work.")
                .setSmallIcon(R.drawable.ic_notification)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .build();

        startForeground(1, notification);
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        // Unregister the VolumeEventReceiver
        if (volumeEventReceiver != null) {
            volumeEventReceiver.unregisterReceiver(this);
        }
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }
}
