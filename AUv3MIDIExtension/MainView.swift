import SwiftUI

struct MainView {
    @EnvironmentObject private var viewModel: MainViewModel
}

extension MainView: View {
    var body: some View {
        VStack {
            Text("**Parameter Tree Observed Changes**")
            Text(viewModel.treeInfo)
        }
    }
}
