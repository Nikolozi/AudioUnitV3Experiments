import Foundation
import AudioToolbox
import AVFoundation
import CoreAudioKit

public class AUv3MIDIDemo: AUAudioUnit {
    private let kernelAdapter: MIDIKernelAdapter

    lazy private var inputBusArray: AUAudioUnitBusArray = {
        AUAudioUnitBusArray(audioUnit: self,
                            busType: .input,
                            busses: [kernelAdapter.inputBus])
    }()

    lazy private var outputBusArray: AUAudioUnitBusArray = {
        AUAudioUnitBusArray(audioUnit: self,
                            busType: .output,
                            busses: [kernelAdapter.outputBus])
    }()

    public override var inputBusses: AUAudioUnitBusArray {
        return inputBusArray
    }

    public override var outputBusses: AUAudioUnitBusArray {
        return outputBusArray
    }

    public override init(componentDescription: AudioComponentDescription,
                         options: AudioComponentInstantiationOptions = []) throws {

        // Create the adapter to communicate to the underlying C++ DSP code.
        kernelAdapter = MIDIKernelAdapter()

        // Create the super class.
        try super.init(componentDescription: componentDescription, options: options)

        // Log the component description values.
        log(componentDescription)
    }

    private func log(_ acd: AudioComponentDescription) {

        let info = ProcessInfo.processInfo
        print("\nProcess Name: \(info.processName) PID: \(info.processIdentifier)\n")

        let message = """
        AUv3MIDIDemo (
                  type: \(acd.componentType.stringValue)
               subtype: \(acd.componentSubType.stringValue)
          manufacturer: \(acd.componentManufacturer.stringValue)
                 flags: \(String(format: "%#010x", acd.componentFlags))
        )
        """
        print(message)
    }

    public override var maximumFramesToRender: AUAudioFrameCount {
        get {
            return kernelAdapter.maximumFramesToRender
        }
        set {
            if !renderResourcesAllocated {
                kernelAdapter.maximumFramesToRender = newValue
            }
        }
    }

    public override func allocateRenderResources() throws {
        try super.allocateRenderResources()
        kernelAdapter.allocateRenderResources()
        kernelAdapter.setMIDIOutputEventBlock(self.midiOutputEventBlock)
    }

    public override func deallocateRenderResources() {
        super.deallocateRenderResources()
        kernelAdapter.deallocateRenderResources()
    }
    
    // A Boolean value that indicates whether the audio unit can process the input
    // audio in-place in the input buffer without requiring a separate output buffer.
    public override var canProcessInPlace: Bool {
        return true
    }

    public override var internalRenderBlock: AUInternalRenderBlock {
        return kernelAdapter.internalRenderBlock()
    }
}
