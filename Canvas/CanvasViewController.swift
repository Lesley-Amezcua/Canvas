//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Nicholas Rosas on 3/14/18.
//  Copyright © 2018 Nicholas Rosas. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    @IBOutlet weak var downArrowImgView: UIImageView!
    
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFAce: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trayDownOffset = 160
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapCanvas(sender:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didDoubleTapCanvas(sender: UITapGestureRecognizer) {
        for case let faceView as UIImageView in self.view.subviews {
            faceView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let PI = 3.14157
    var rot = 3.14157
    var x = -1
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)
        
        
        
        if sender.state == .began {
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed{
            print("change\n")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            x *= -1
            
            if (x < 0) {
                rot = 0.0
            } else {
                rot = PI
            }
            
        }
        else if sender.state == .ended{
            print("end\n")
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            }
            else{
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                }, completion: nil)
            }
            UIView.animate(withDuration:0.2, delay: 0.0,
                options: [], animations: { () -> Void in
                    self.downArrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(self.rot))
            }, completion: nil)
        }
        
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        
        
        if sender.state == .began {
            let imageView = sender.view as! UIImageView
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan(sender:)))
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didDoubleTapImage(sender:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFAce = UIImageView(image: imageView.image)
            newlyCreatedFAce.isUserInteractionEnabled = true
            newlyCreatedFAce.addGestureRecognizer(panGestureRecognizer)
            newlyCreatedFAce.addGestureRecognizer(tapGestureRecognizer)
            view.addSubview(newlyCreatedFAce)
            newlyCreatedFAce.center = imageView.center
            newlyCreatedFAce.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFAce.center
            
            
        }
        else if sender.state == .changed{
           newlyCreatedFAce.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        }
        else if sender.state == .ended{
            
        }
    }
    func didPan(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            newlyCreatedFAce = sender.view as! UIImageView // to get the face that we panned on.
            newlyCreatedFaceOriginalCenter = newlyCreatedFAce.center // so we can offset by translation later.
            
            UIView.animate(withDuration:0.4, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFAce.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
        } else if sender.state == .changed {
            print("Gesture is changing")
            newlyCreatedFAce.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            print("Gesture ended")
            UIView.animate(withDuration:0.4, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFAce.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }, completion: nil)
        }
    }
    func didDoubleTapImage(sender: UITapGestureRecognizer) {
        let faceView = sender.view as! UIImageView
        faceView.removeFromSuperview()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
