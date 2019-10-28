import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack(spacing: viewModel.spacing) {
                ForEach(viewModel.viewData, id: \.self) { id in
                    ChildView(id: id).environmentObject(self.viewModel)
                }
            }
            .animation(.easeInOut)
            .padding()
        }
    }
}

class ContentViewModel: ObservableObject {
    var viewData: [Int] = Array(0..<10)
    @Published var doneOrganising: Bool?
    let width: CGFloat = 200
    let height: CGFloat = 300
    let spacing: CGFloat = 10

    var current: Int?
    var dragedOffset: CGFloat = 0

    private var cancellables: Set<AnyCancellable> = []

    init() {
        $doneOrganising.sink {[weak self] done in
            guard let self = self,
                let done = done, done else { return }
            if let id = self.current,
                let index = self.viewData.firstIndex(of: id) {
                let element = self.viewData.remove(at: index)
                self.viewData.insert(element, at: self.proposedIndex(for: index))
            }
        }.store(in: &cancellables)
    }

    func proposedIndex(for index: Int) -> Int {
        let newIndex = index + Int(dragedOffset / (width + spacing))
        return max(min(newIndex, viewData.count), 0)
    }
}
