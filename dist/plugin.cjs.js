'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const VolumeEventReceiver = core.registerPlugin('VolumeEventReceiver', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.VolumeEventReceiverWeb()),
});

class VolumeEventReceiverWeb extends core.WebPlugin {
    async startListening() {
        return { status: 'Not implemented for web' };
    }
    async stopListening() {
        return { status: 'Not implemented for web' };
    }
}

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    VolumeEventReceiverWeb: VolumeEventReceiverWeb
});

exports.VolumeEventReceiver = VolumeEventReceiver;
//# sourceMappingURL=plugin.cjs.js.map
