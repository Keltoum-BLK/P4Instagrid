//
//  InstagridViewController.swift
//  Instagrid
//
//  Created by Keltoum Belkadi on 14/01/2021.
//

import UIKit
import Photos

class InstagridViewController: UIViewController {
    //buttons to select a layout
    @IBOutlet weak var layout1Button: UIButton!
    @IBOutlet weak var layout2Button: UIButton!
    @IBOutlet weak var layout3Button: UIButton!
    
    //swipeUp and SwipeLeft
    @IBOutlet weak var swipeLabel: UILabel!
    
    //buttons to pic a photo
    @IBOutlet weak var buttonLeftDown: UIButton!
    @IBOutlet weak var buttonRightDown: UIButton!
    @IBOutlet weak var buttonLeftUp: UIButton!
    @IBOutlet weak var buttonRightUp: UIButton!
    
    //
    @IBOutlet weak var centralView: UIView!
    
    private var buttonImage: UIButton?
    private var imagePicker: UIImagePickerController?
    
    // MARK:method that allows to display supplements to the view
    override func viewDidLoad() {
        super.viewDidLoad()
        layout1Button.setImage(UIImage(named: "Layout1"), for: .normal)
        
        layout1Button.tag = 1
        layout2Button.tag = 2
        layout3Button.tag = 3
        
        buttonRightUp.tag = 1
        buttonLeftUp.tag = 2
        buttonRightDown.tag = 3
        buttonLeftDown.tag = 4
        
        layout1Button.setImage(UIImage(named: "layoutSelected"), for: .selected)
        
        layout2Button.setImage(UIImage(named: "Layout2"), for: .normal)
        
        layout2Button.setImage(UIImage(named: "layoutSelected2"), for: .selected)
        
        layout3Button.setImage(UIImage(named: "Layout3"), for: .normal)
        
        layout3Button.setImage(UIImage(named: "layoutSelected3"), for: .selected)
        
        addGestureRecognizer()
    }
    
    // MARK: methods to select a layout and add new photos to the layout
    //Select a Layout to add photos
    @IBAction func layout1Tapped(_ sender: UIButton) {
        print("tapé")
        print(sender.tag)
        
        switch sender.tag {
        case 1:
            layout1Button.isSelected = true
            layout2Button.isSelected = false
            layout3Button.isSelected = false
            buttonLeftUp.isHidden = true
            buttonLeftDown.isHidden = false
            
        case 2:
            layout2Button.isSelected = true
            layout1Button.isSelected = false
            layout3Button.isSelected = false
            buttonLeftDown.isHidden = true
            buttonLeftUp.isHidden = false
        case 3:
            layout3Button.isSelected = true
            layout1Button.isSelected = false
            layout2Button.isSelected = false
            buttonLeftUp.isHidden = false
            buttonLeftDown.isHidden = false
        default:
            break
        }
    }
    //add a photo
    @IBAction func addNewPhoto(_ sender: UIButton) {
        print("tapé")
        if checkPermission() {
            buttonImage = sender
            imagePicker = UIImagePickerController()
            imagePicker?.delegate = self
            imagePicker?.sourceType = .savedPhotosAlbum
            guard let secureImagePicker = imagePicker else { return }
            present(secureImagePicker, animated: true)
        } else {
            let accessError = UIAlertController(title: "Autorisation refusée", message: "Veuillez autoriser l'accès dans vos paramètres téléphone.", preferredStyle: UIAlertController.Style.alert)
            accessError.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(accessError, animated: true, completion: nil)
        }
        // else afficher popup:  un message d'erreur , veuillez accéder aux parametre du telephone 
    }
    // MARK: gesture activation by swipe up and swipe left
    private func addGestureRecognizer() {
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunction(_:)))
        swipeUpGestureRecognizer.direction = .up
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeFunction(_:)))
        swipeLeftGestureRecognizer.direction = .left
        
        view.addGestureRecognizer(swipeUpGestureRecognizer)
        view.addGestureRecognizer(swipeLeftGestureRecognizer)
    }
    // MARK: view change check
    @objc private func swipeFunction(_ recognizer: UISwipeGestureRecognizer) {
        if recognizer.direction == .up {
            print("up")
            shareTheLayout()
        } else if recognizer.direction == .left {
            print("left")
            shareTheLayout()
        }
    }
    // MARK: change label text by view orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        swipeLabel.text =  (UIDevice.current.orientation.isPortrait) ? "^\nSwipe up to share" : "<\nSwipe left to share"
    }
    
    //MARK: Share the layout with UIActivityViewCOntroller
    private func shareTheLayout(){
        guard let imageView = centralView.asImage() else { return }
        let ac = UIActivityViewController(activityItems: [imageView as UIImage], applicationActivities: nil)
        present(ac, animated: true, completion: nil)
    }
    //checkPermission ask access to the library of the device.
    func checkPermission() -> Bool {
        // By default, we consider we don't have it
        var status = false
        // We go catch the current status
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            // We do have the autorisation. Everything is good!
            status = true
        case .notDetermined:
            // The user didn't gave the autorisation yet. So we go ask him
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                if newStatus ==  PHAuthorizationStatus.authorized {
                    // the user gave us his blessing
                    status = true
                }
            })
        case .denied:
            // The user denied..
            break
        case .restricted:
            // The user denied..
            break
        case .limited:
            print("ok")
        @unknown default:
            // Unknown case - update for swift 5
            break
        }
        // Value ready to be returned
        return status
    }
}
// MARK: the implementation of blind communication methods between the controller and the view
extension InstagridViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //setting up the UIImagePickerController to select and assign the photo
    func imagePickerController(_ _picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any] ) {
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            buttonImage?.setImage(nil, for: .normal)
            buttonImage?.setBackgroundImage(originalImage, for: .normal)
            dismiss(animated: true) {
                self.imagePicker = nil
                self.buttonImage = nil
            }
        }
    }
}

