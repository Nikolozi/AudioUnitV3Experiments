import AUv3FilterFramework

extension AUv3MIDIDemoViewController: AUAudioUnitFactory {

    public func createAudioUnit(with componentDescription: AudioComponentDescription) throws -> AUAudioUnit {
        let audioUnit = try AUv3MIDIDemo(componentDescription: componentDescription, options: [])

        Task { @MainActor in
            setAudioUnit(audioUnit)
        }

        return audioUnit
    }
}
