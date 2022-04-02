//
//  CameraViewController.swift
//  Parstogram
//
//  Created by Charles Kypros on 3/22/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts")
        post["Author"] = PFUser.current()!
        post["Caption"] = commentField.text!
        post["Image"] = PFFileObject(name: "photo.png", data: imageView.image!.pngData()!)
        
        post.saveInBackground { success, error in
            if success {
                self.dismiss(animated: true)
            } else {
                print("Error saving image")
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            // Take a picture with the camera
            let picker = getPicker()
            picker.sourceType = .camera
            present(picker, animated: true)
        } else {
            // Display camera is unavailable alert
            let alertController = UIAlertController(
                    title: "Camera Error",
                    message: "Sorry, camera is not currently available",
                    preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func onPhotoLibraryButton(_ sender: Any) {
        let picker = getPicker()
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func getPicker() -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        let scaledSize = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: scaledSize)
        imageView.image = scaledImage
        
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
