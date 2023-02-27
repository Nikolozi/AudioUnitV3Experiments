import SwiftUI

struct MainView {
    @EnvironmentObject private var viewModel: MainViewModel
}

extension MainView: View {
    var body: some View {
        Text("AUv3 Demo")
    }
}
