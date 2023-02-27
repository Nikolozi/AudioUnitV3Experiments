final class MainViewModel: ObservableObject {
    private(set) var audioUnit: SharedAUAudioUnit

    init(audioUnit: SharedAUAudioUnit) {
        self.audioUnit = audioUnit
    }
}
