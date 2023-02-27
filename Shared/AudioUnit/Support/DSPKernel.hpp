/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The utility code to manage scheduled parameters in an audio unit implementation.
*/

#ifndef DSPKernel_h
#define DSPKernel_h

#import <AudioToolbox/AudioToolbox.h>
#import <algorithm>

template <typename T>
T clamp(T input, T low, T high) {
    return std::min(std::max(input, low), high);
}

// Put your DSP code into a subclass of DSPKernel.
class DSPKernel {
public:
    virtual void process(AUAudioFrameCount frameCount, AUAudioFrameCount bufferOffset) = 0;
    virtual void startRamp(AUParameterAddress address, AUValue value, AUAudioFrameCount duration) = 0;

    // Override to handle MIDI events.
    virtual void handleMIDIEvent(AUMIDIEvent const& midiEvent) {}

    void processWithEvents(AudioTimeStamp const* timestamp, AUAudioFrameCount frameCount, AURenderEvent const* events);

    AUAudioFrameCount maximumFramesToRender() const {
        return maxFramesToRender;
    }

    void setMaximumFramesToRender(const AUAudioFrameCount &maxFrames) {
        maxFramesToRender = maxFrames;
    }

    void setMIDIOutputEventBlock(AUMIDIOutputEventBlock midiOutputEventBlock) {
        _midiOutputEventBlock = midiOutputEventBlock;
    }

    void setBuffers(AudioBufferList* inBufferList, AudioBufferList* outBufferList) {
        inBufferListPtr = inBufferList;
        outBufferListPtr = outBufferList;
    }

protected:
    AUEventSampleTime _now = 0;

    AudioBufferList* inBufferListPtr = nullptr;
    AudioBufferList* outBufferListPtr = nullptr;

    AUMIDIOutputEventBlock _midiOutputEventBlock = nullptr;

private:
    void handleOneEvent(AURenderEvent const* event);
    void performAllSimultaneousEvents(AUEventSampleTime now, AURenderEvent const*& event);

    AUAudioFrameCount maxFramesToRender = 512;
};

#endif /* DSPKernel_h */
