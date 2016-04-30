//
//  File.swift
//  SmartStreetAdmin
//
//  Created by Anhad S Bhasin on 4/28/16.
//  Copyright © 2016 Anhad S Bhasin. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class RegisterTree : UITableViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    @IBOutlet weak var treeID: UITextField!
    @IBOutlet weak var profile: UITextField!
    @IBOutlet weak var manufacturerID: UITextField!
    @IBOutlet weak var batchID: UITextField!
    @IBOutlet weak var installed: UISwitch!

    var objCaptureSession:AVCaptureSession?
    var objCaptureVideoPreviewLayer:AVCaptureVideoPreviewLayer?
    var vwQRCode:UIView?
    
    @IBAction func submitTree(sender: UIButton) {
        
        let treeRegistration = PFObject(className: "TreeRegistration")
        treeRegistration["TreeId"] = treeID.text
        treeRegistration["BatchNumber"] = batchID.text
        treeRegistration["Profile"] = profile.text
        treeRegistration["ManufacturerId"] = manufacturerID.text
        treeRegistration["Installed"] = installed.on
        
        treeRegistration.saveInBackgroundWithBlock {(success:Bool, error:NSError?) in
            if (success) {
                print("Tree registration record saved to database")
                let alert = UIAlertController(title: "Success", message: "Tree Registration Successful", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: { action in print("Pass Alert Shown")}))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.reset()
                
            } else {
                
                print("Error")
                 let alert = UIAlertController(title: "Failed", message: "Tree Registration Unsuccessful", preferredStyle: UIAlertControllerStyle.Alert)

                alert.addAction(UIAlertAction(title: "Done",
                    style: UIAlertActionStyle.Default,
                    handler: {(alert: UIAlertAction!) in print("Fail Alert Shown")}))
                self.presentViewController(alert, animated: true, completion: nil)
                self.reset()

                
            }
        }
        
    }
    func reset(){
        
        self.treeID.text = ""
        self.profile.text = ""
        self.manufacturerID.text = ""
        self.batchID.text = ""
        self.installed.on = true

    }
    
    
    @IBAction func registerUsingQRCode(sender: UIButton)
    {
        self.configureVideoCapture()
        self.addVideoPreviewLayer()
        self.initializeQRView()
        
    }
    func configureVideoCapture() {
        let objCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var error:NSError?
        let objCaptureDeviceInput: AnyObject!
        do {
            objCaptureDeviceInput = try AVCaptureDeviceInput(device: objCaptureDevice) as AVCaptureDeviceInput
            
        } catch let error1 as NSError {
            error = error1
            objCaptureDeviceInput = nil
        }
        if (error != nil) {
            let alertView:UIAlertView = UIAlertView(title: "Device Error", message:"Device not Supported for this Application", delegate: nil, cancelButtonTitle: "Ok Done")
            alertView.show()
            return
        }
        objCaptureSession = AVCaptureSession()
        objCaptureSession?.addInput(objCaptureDeviceInput as! AVCaptureInput)
        let objCaptureMetadataOutput = AVCaptureMetadataOutput()
        objCaptureSession?.addOutput(objCaptureMetadataOutput)
        objCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        objCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
    }
    
    
    func addVideoPreviewLayer()
    {
        objCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: objCaptureSession)
        objCaptureVideoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        objCaptureVideoPreviewLayer?.frame = view.layer.bounds
        self.view.layer.addSublayer(objCaptureVideoPreviewLayer!)
        objCaptureSession?.startRunning()
        
    }
    
    func initializeQRView() {
        vwQRCode = UIView()
        vwQRCode?.layer.borderColor = UIColor.redColor().CGColor
        vwQRCode?.layer.borderWidth = 5
        self.view.addSubview(vwQRCode!)
        self.view.bringSubviewToFront(vwQRCode!)
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            vwQRCode?.frame = CGRectZero
            
            return
        }
        let objMetadataMachineReadableCodeObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if objMetadataMachineReadableCodeObject.type == AVMetadataObjectTypeQRCode {
            let objBarCode = objCaptureVideoPreviewLayer?.transformedMetadataObjectForMetadataObject(objMetadataMachineReadableCodeObject as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            vwQRCode?.frame = objBarCode.bounds;
            if objMetadataMachineReadableCodeObject.stringValue != nil {
                
                print(objMetadataMachineReadableCodeObject.stringValue)
                
                let decodedStr = objMetadataMachineReadableCodeObject.stringValue
                let parts = decodedStr.componentsSeparatedByString(";")
                var dict = [String]()
                
                for part in parts {
                    //print(part)
                    let keyValue = part.componentsSeparatedByString("=")
                    // print(keyValue[1])
                    dict.append(keyValue[1])
                }
                
                treeID.text = dict[0]
                profile.text = dict[1]
                manufacturerID.text = dict[2]
                batchID.text = dict[3]
                installed.on = dict[4] == "true"
                
                objCaptureSession?.stopRunning()
                objCaptureVideoPreviewLayer?.removeFromSuperlayer()
                vwQRCode?.removeFromSuperview()
                
            }
        }
    }
}


