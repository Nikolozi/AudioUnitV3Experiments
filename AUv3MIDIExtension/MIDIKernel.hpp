#pragma once

#import "DSPKernel.hpp"
#import "ParameterRamper.hpp"
#import <vector>

class MIDIKernel : public DSPKernel {
public:

    // MARK: Member Functions

    MIDIKernel()  {}

    void init(int channelCount, double inSampleRate) {

    }

    void reset() {

    }

    void setParameter(AUParameterAddress address, AUValue value) {

    }

    AUValue getParameter(AUParameterAddress address) {
        return 0;
    }

    void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) override {

    }

    void handleMIDIEvent(AUMIDIEvent const& event) override {
        if (_midiOutputEventBlock) {
            _midiOutputEventBlock(_now, 0, event.length, event.data);
        }
    }

    void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) override {

    }
};
