#import <AudioToolbox/AudioToolbox.h>

@class AUv3FilterDemoViewController;

NS_ASSUME_NONNULL_BEGIN

@interface MIDIKernelAdapter : NSObject

@property (nonatomic) AUAudioFrameCount maximumFramesToRender;
@property (nonatomic, readonly) AUAudioUnitBus *inputBus;
@property (nonatomic, readonly) AUAudioUnitBus *outputBus;

- (void)allocateRenderResources;
- (void)deallocateRenderResources;

- (void)setMIDIOutputEventBlock:(nullable AUMIDIOutputEventBlock)midiOutputEventBlock;

- (AUInternalRenderBlock)internalRenderBlock;

@end

NS_ASSUME_NONNULL_END
