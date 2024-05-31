package com.corrindata.volumeeventreceiver;

import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.util.Log;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "VolumeEventReceiver")
public class VolumeEventReceiverPlugin extends Plugin {

    private static VolumeEventReceiverPlugin instance;
    private Context context;

    @Override
    public void load() {
        super.load();
        context = getContext();
        instance = this;
    }

    public static VolumeEventReceiverPlugin getInstance() {
        return instance;
    }


    @PluginMethod
    public void startListening(PluginCall call) {
        Intent serviceIntent = new Intent(context, VolumeEventReceiverService.class);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                context.startForegroundService(serviceIntent);
            }
        call.resolve(new JSObject().put("status", "started"));
    }

    @PluginMethod
    public void stopListening(PluginCall call) {
        Intent serviceIntent = new Intent(context, VolumeEventReceiverService.class);
        context.stopService(serviceIntent);
        call.resolve(new JSObject().put("status", "stopped"));
    }

    public void notifyVolumeEvent() {
        JSObject ret = new JSObject();
        ret.put("event", "volumeChanged");
        notifyListeners("volumeButtonEvent", ret);
    }
}
