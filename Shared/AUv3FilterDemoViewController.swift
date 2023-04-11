/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view controller for the AUv3FilterDemo audio unit that manages the interactions between a FilterView and the audio unit's parameters.
*/

import CoreAudioKit

final class DisplayLinkWrapper {
    private var displayLink: CADisplayLink?

    func callback(_ callback: @escaping () -> Void) {
        displayLink?.invalidate()

        let displayLink = CADisplayLink(
            target: UnownedTarget(callback: callback),
            selector: #selector(UnownedTarget.displayLinkCallback)
        )

        displayLink.add(to: .current, forMode: .common)

        self.displayLink = displayLink
    }

    deinit {
        displayLink?.invalidate()
    }
}

private final class UnownedTarget: NSObject {
    private let callback: () -> Void

    init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    @objc func displayLinkCallback() {
        callback()
    }

    deinit {
        debugPrint("DisplayLinkWrapper.UnownedTarget - deinit")
    }
}


public class AUv3FilterDemoViewController: AUViewController {
    private var frameCounter: Int = 0
    private let displayLink = DisplayLinkWrapper()

    let compact = AUAudioUnitViewConfiguration(width: 400, height: 100, hostHasController: false)
    let expanded = AUAudioUnitViewConfiguration(width: 800, height: 500, hostHasController: false)

    private var viewConfig: AUAudioUnitViewConfiguration!

    private var cutoffParameter: AUParameter!
    private var resonanceParameter: AUParameter!
    private var parameterObserverToken: AUParameterObserverToken?

    @IBOutlet weak var filterView: FilterView!

    @IBOutlet weak var frequencyTextField: UITextField!
    @IBOutlet weak var resonanceTextField: UITextField!
    
    var observer: NSKeyValueObservation?

    private let console = UITextView()

    var needsConnection = true

    @IBOutlet var expandedView: UIView! {
        didSet {
            expandedView.setBorder(color: .black, width: 1)
        }
    }

    @IBOutlet var compactView: UIView! {
        didSet {
            compactView.setBorder(color: .black, width: 1)
        }
    }

    // Always support width: 0 height:0, which is the default and largest view.
    public var viewConfigurations: [AUAudioUnitViewConfiguration] {
        return [expanded, compact]
    }

    /*
     When this view controller instantiates within the FilterDemoApp, the
     system creates its audio unit independently and passes it to the view
     controller here.
     */
    public var audioUnit: AUv3FilterDemo? {
        didSet {
            audioUnit?.viewController = self
            /*
             The app may be on a dispatch worker queue processing an XPC request at
             this time, and quite possibly the main queue is busy creating the
             view. To be thread-safe, dispatch onto the main queue.

             It's also possible that the app is already on the main queue, so to
             protect against deadlock in that case, dispatch asynchronously.
             */
            performOnMain {
                if self.isViewLoaded {
                    self.connectViewToAU()
                }
            }
        }
    }

    // MARK: Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        console.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(console)

        displayLink.callback { [weak self] in
            guard let self else {
                assert(false)
                return
            }

            if frameCounter > 240 {
                assert(view.window != nil)
                assert(view.superview != nil)
                logToConsole("==== window isHidden = \(view.window!.isHidden)")
                logToConsole("==== superview isHidden = \(view.superview!.isHidden)")
                frameCounter = 0
            } else {
                frameCounter += 1
            }
        }
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        console.frame = view.bounds
    }

    private func connectViewToAU() {
        guard needsConnection, let paramTree = audioUnit?.parameterTree else { return }

        // Find the cutoff and resonance parameters in the parameter tree.
        guard let cutoff = paramTree.value(forKey: "cutoff") as? AUParameter,
            let resonance = paramTree.value(forKey: "resonance") as? AUParameter else {
                fatalError("Required AU parameters not found.")
        }

        // Set the instance variables.
        cutoffParameter = cutoff
        resonanceParameter = resonance

        // Observe major state changes like a user selecting a user preset.
        observer = audioUnit?.observe(\.allParameterValues) { object, change in
            DispatchQueue.main.async {
                self.updateUI()
            }
        }

        // Observe value changes to the cutoff and resonance parameters.
        parameterObserverToken =
            paramTree.token(byAddingParameterObserver: { [weak self] address, value in
                guard let self = self else { return }

                // An arbitrary queue is calling this closure. Ensure
                // all UI updates dispatch back to the main thread.
                if [cutoff.address, resonance.address].contains(address) {
                    DispatchQueue.main.async {
                        self.updateUI()
                    }
                }
            })

        // Indicate the view and the audio unit have a connection.
        needsConnection = false

        // Sync the UI with the parameter state.
        updateUI()
    }

    private func updateUI() {
        // Set the latest values on the graph view.
        filterView.frequency = cutoffParameter.value
        filterView.resonance = resonanceParameter.value

        // Set the latest text field values.
        frequencyTextField.text = cutoffParameter.string(fromValue: nil)
        resonanceTextField.text = resonanceParameter.string(fromValue: nil)

        updateFilterViewFrequencyAndMagnitudes()
    }

    @IBAction func frequencyUpdated(_ sender: UITextField) {
        update(parameter: cutoffParameter, with: sender)
    }

    @IBAction func resonanceUpdated(_ sender: UITextField) {
        update(parameter: resonanceParameter, with: sender)
    }

    func update(parameter: AUParameter, with textField: UITextField) {
        guard let value = (textField.text as NSString?)?.floatValue else { return }
        parameter.value = value
        textField.text = parameter.string(fromValue: nil)
    }

    func performOnMain(_ operation: @escaping () -> Void) {
        if Thread.isMainThread {
            operation()
        } else {
            DispatchQueue.main.async {
                operation()
            }
        }
    }
}

extension AUv3FilterDemoViewController {
    private func logToConsole(_ text: String) {
        console.text = """
        \(console.text ?? "")
        \(text)
        """
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logToConsole("== viewWillAppear ==")
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logToConsole("== viewDidAppear ==")
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logToConsole("== viewWillDisappear ==")
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logToConsole("== viewDidDisappear ==")
    }
}

extension AUv3FilterDemoViewController: FilterViewDelegate {
    // MARK: FilterViewDelegate

    func updateFilterViewFrequencyAndMagnitudes() {
        guard let audioUnit = audioUnit else { return }

        // Get an array of frequencies from the view.
        let frequencies = filterView.frequencyDataForDrawing()

        // Get the corresponding magnitudes from the audio unit.
        let magnitudes = audioUnit.magnitudes(forFrequencies: frequencies)

        filterView.setMagnitudes(magnitudes)
    }

    func filterViewTouchBegan(_ filterView: FilterView) {
        resonanceParameter.setValue(filterView.resonance,
                                    originator: parameterObserverToken,
                                    atHostTime: 0,
                                    eventType: .touch)
        
        cutoffParameter.setValue(filterView.frequency,
                                    originator: parameterObserverToken,
                                    atHostTime: 0,
                                    eventType: .touch)
    }
    
    func filterView(_ filterView: FilterView, didChangeResonance resonance: Float) {
        resonanceParameter.setValue(resonance,
                                    originator: parameterObserverToken,
                                    atHostTime: 0,
                                    eventType: .value)
        updateFilterViewFrequencyAndMagnitudes()
    }

    func filterView(_ filterView: FilterView, didChangeFrequency frequency: Float) {
        cutoffParameter.setValue(frequency,
                                 originator: parameterObserverToken,
                                 atHostTime: 0,
                                 eventType: .value)
        updateFilterViewFrequencyAndMagnitudes()
    }

    func filterView(_ filterView: FilterView, didChangeFrequency frequency: Float, andResonance resonance: Float) {
        
         resonanceParameter.setValue(resonance,
                                    originator: parameterObserverToken,
                                    atHostTime: 0,
                                    eventType: .value)
        
        cutoffParameter.setValue(frequency,
                                 originator: parameterObserverToken,
                                 atHostTime: 0,
                                 eventType: .value)
        
        updateFilterViewFrequencyAndMagnitudes()
    }

    func filterViewTouchEnded(_ filterView: FilterView) {
        resonanceParameter.setValue(filterView.resonance,
                                    originator: nil,
                                    atHostTime: 0,
                                    eventType: .release)
        
        cutoffParameter.setValue(filterView.frequency,
                                    originator: nil,
                                    atHostTime: 0,
                                    eventType: .release)
    }
    
    func filterViewDataDidChange(_ filterView: FilterView) {
        updateFilterViewFrequencyAndMagnitudes()
    }
}

#if os(iOS)
extension AUv3FilterDemoViewController: UITextFieldDelegate {
    // MARK: UITextFieldDelegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
#endif
