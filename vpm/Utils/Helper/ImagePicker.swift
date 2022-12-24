import Foundation
import UIKit
import Photos

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage,String) -> ())?;
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage,String) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        
//        let cameraAction = UIAlertAction(title: "Camera", style: .default){
//            UIAlertAction in
            self.openCamera()
//        }
//        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){
//            UIAlertAction in
//            self.openGallery()
//        }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
//            UIAlertAction in
//        }
        
        // Add the actions
        picker.delegate = self
//        alert.addAction(cameraAction)
//        alert.addAction(gallaryAction)
//        alert.addAction(cancelAction)
//        alert.popoverPresentationController?.sourceView = self.viewController!.view
//
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.viewController!.view
            popoverPresentationController.sourceRect = self.viewController!.view.bounds
            popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }
//
//        DispatchQueue.main.async {
//            viewController.present(self.alert, animated: true, completion: nil)
//        }
    }
    func openCamera(){
//        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            picker.allowsEditing = true
            DispatchQueue.main.async {
                self.viewController!.present(self.picker, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in }))
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        DispatchQueue.main.async {
            self.viewController!.present(self.picker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController,
//    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        if let image = info[.editedImage] as? UIImage {
//            pickImageCallback?(image)
//        } else {
//            print("Other source")
//        }
//
//    }
    
      // For Swift 4.2
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
          picker.dismiss(animated: true, completion: nil)
          guard let image = info[.originalImage] as? UIImage else {
              viewController?.view.makeToast("Expected a dictionary containing an image, but was provided the following: \(info)")
              fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
          }
          
          if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
              pickImageCallback?(image, imageURL.lastPathComponent)
          }else{
              pickImageCallback?(image, "image_\(ProcessInfo().globallyUniqueString).jpeg")
          }
      }
    
    
    
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        
    }
    
}
