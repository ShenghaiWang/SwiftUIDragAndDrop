import SwiftUI

struct ChildView: View {
    let id: Int
    @State private var xOffset: CGFloat = 0 {
        didSet {
            viewModel.dragedOffset = _xOffset.wrappedValue
        }
    }
    @State private var dragging = false
    @EnvironmentObject var viewModel: ContentViewModel

    var body: some View {
        HStack {
            Text("Drag or Tap me \(id)")
            Button(action: {
                self.viewModel.current = self.id
                self.viewModel.doneOrganising = true
            }) {
                Text("Tap")
            }
        }.frame(width: viewModel.width, height: viewModel.height, alignment: .center)
        .background(Color.red)
        .border(Color.yellow, width: dragging ? 2 : 0)
        .cornerRadius(8)
        .offset(x: dragging ? xOffset : 0)
        .gesture(DragGesture().onEnded(dragEnded).onChanged(dragChanged))
        .zIndex(dragging ? Double.greatestFiniteMagnitude : Double(id))
    }

    func dragEnded(gesture: DragGesture.Value) {
        dragging = false
        viewModel.current = id
        viewModel.doneOrganising = true
    }

    func dragChanged(gesture: DragGesture.Value) {
        dragging = true
        xOffset = gesture.location.x - gesture.startLocation.x
    }
}
