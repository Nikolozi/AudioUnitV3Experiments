final class MainViewModel: ObservableObject {
    private(set) var audioUnit: AUAudioUnit

    @Published private(set) var treeInfo = ""

    private var treeObserver: NSKeyValueObservation?

    init(audioUnit: AUAudioUnit) {
        self.audioUnit = audioUnit

        treeObserver = audioUnit.observe(\.parameterTree, options: .new) { [weak self] au, tree in
            guard let unwrapped = tree.newValue else {
                assert(false)
                return
            }
            
            self?.loadTreeInfo(parameterTree: unwrapped)
        }
    }

    private func loadTreeInfo(parameterTree: AUParameterTree!) {
        Task { @MainActor in
            treeInfo = parameterTree.allParameters.reduce("") { result, parameter in
                "\(result)\n\(parameter.address) - \(parameter.displayName)"
            }
        }
    }
}
