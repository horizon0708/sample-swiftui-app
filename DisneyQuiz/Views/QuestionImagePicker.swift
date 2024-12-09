//
//  QuestionImageView.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/28/24.
//

import SwiftUI
import PhotosUI

enum ImageState  {
    case empty, loading(Progress), success(UIImage), failure(Error)
}

struct QuestionImagePicker: View {
    var successHandler: ((UIImage) -> Void)?
    var errorHandler: ((Error) ->Void)?
    
    @State var imageState: ImageState = .empty
    @State var imageSelection: PhotosPickerItem? = nil
    @Binding var imageUrl: URL?
    
    var body: some View {
        PhotosPicker(selection: $imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            switch imageState {
            case .success(let image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(5)
            case .loading:
                ProgressView()
            case .empty:
                if let imageUrl, let uiImage = FileManager.load(imageUrl) {
                    Image(uiImage: uiImage)
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .cornerRadius(5)
                } else {
                    Image(systemName: "photo.badge.plus")
                }
            case .failure:
                Image(systemName: "exclamationmark.triangle.fill")
            }
        }
                     .font(.system(size: 40))
                     .foregroundColor(.gray)
                     .onChange(of: imageSelection, { oldValue, imageSelection in
                         if let imageSelection {
                             let progress = loadTransferable(from: imageSelection)
                             imageState = .loading(progress)
                         } else {
                             imageState = .empty
                         }
                     })
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else { return }
                switch result {
                case .success(let data?):
                    if let uiImage = UIImage(data: data) {
                        self.imageState = .success(uiImage)
                        if let handler = self.successHandler
                        {
                            handler(uiImage)
                        }
                    } else {
                        self.imageState = .empty
                    }
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

#Preview {
    @State var question = sampleQuestions[0]
    return QuestionImagePicker(
        imageState: .empty,
        imageUrl: $question.imageUrl
    )
}
