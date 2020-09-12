import SwiftUI

struct ContentView: View {
  @State var isPresentingImagePicker: Bool = false
  @State var isPresentingConfig: Bool = true
  @State var image: UIImage?
  @State var imageOffset: CGPoint = .zero
  @State var imageScale: CGFloat = 1.0

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        ZStack {
          Color(.systemBackground)
          if let image = image {
            Image(uiImage: image)
              .scaleEffect(imageScale)
              .frame(
                width: image.size.width * image.scale * imageScale,
                height: image.size.height * image.scale * imageScale
              )
              .offset(x: imageOffset.x, y: imageOffset.y)
          } else {
            Text("No image loaded")
          }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(
          width: geometry.size.width,
          height: geometry.size.height
        )
        .onDrag(updateOffset: $imageOffset)
        .onMagnify(updateScale: $imageScale)
        .onTapGesture {
          withAnimation(.easeInOut) {
            self.isPresentingConfig.toggle()
          }
        }

        VStack {
          Spacer()
          if isPresentingConfig {
            ConfigView(
              importAction: { self.isPresentingImagePicker = true },
              exportAction: {
                guard let image = self.image else { return }

                let croppingRect = image.croppingRect(
                  size: geometry.sizeIgnoringSafeArea,
                  offset: self.imageOffset,
                  scale: self.imageScale
                )

                let exportedImage = image
                  .cropped(to: croppingRect)
                // TODO: resize image

                if let image = exportedImage {
                  // TODO: save to photo library
                  // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                  self.image = image
                  self.imageOffset = .zero
                  self.imageScale = 1.0
                }
              }
            )
            .transition(
              AnyTransition
                .move(edge: .bottom)
                .combined(with: .offset(y: geometry.safeAreaInsets.bottom))
            )
          }
        }
      }
    }
    .navigationBarHidden(true)
    .sheet(isPresented: $isPresentingImagePicker) {
      ImagePicker(onImport: {
        self.image = $0
        self.imageOffset = .zero
        self.imageScale = 1.0
      })
    }
  }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
#endif
