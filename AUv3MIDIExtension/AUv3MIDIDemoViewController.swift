import CoreAudioKit
import SwiftUI

@objc(AUv3MIDIDemoViewController)
public class AUv3MIDIDemoViewController: AUViewController {
    /// SwiftUI content is added to this once the AudioUnit is set.
    /// This is required as loadView may not be called before Audio Unit is set.
    private let internalView = UIView()

    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public override func loadView() {
        view = internalView
    }

    public func setAudioUnit(_ audioUnit: AUv3MIDIDemo) {
        let mainViewModel = MainViewModel(audioUnit: audioUnit)

        let mainView = internalView.addSwiftUISubview(
            MainView()
                .environmentObject(mainViewModel),
            parent: self
        )

        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: internalView.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: internalView.rightAnchor),
            mainView.topAnchor.constraint(equalTo: internalView.topAnchor),
            mainView.bottomAnchor.constraint(equalTo: internalView.bottomAnchor),
        ])
    }
}
