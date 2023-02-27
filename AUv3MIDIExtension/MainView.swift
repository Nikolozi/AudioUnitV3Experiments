import SwiftUI

struct MainView {
    @EnvironmentObject private var viewModel: MainViewModel
}

extension MainView: View {
    var body: some View {
        TimelineView(.animation) { _ in
            VStack {
                Text("INPUT Bus Sample Rate \(Int(viewModel.audioUnit.inputBusSampleRate))")
                Text("OUTPUT Bus Sample Rate \(Int(viewModel.audioUnit.outputBusSampleRate))")
            }
        }
    }
}
