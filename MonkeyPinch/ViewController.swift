import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    
    @IBOutlet var bananaPam: UIPanGestureRecognizer!
    @IBOutlet var monkeyPan: UIPanGestureRecognizer!
    
    var chompPlayer:AVAudioPlayer? = nil
    var hehePlayer:AVAudioPlayer? = nil
    
    func loadSound(filename: String) -> AVAudioPlayer {
        let url = Bundle.main.url(forResource: filename, withExtension: "caf")
        var player = AVAudioPlayer()
        do {
            try player = AVAudioPlayer(contentsOf: url!)
            player.prepareToPlay()
        } catch {
            print("Error loading \(url!): \(error.localizedDescription)")
        }
        return player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a filtered array of just the monkey and banana image views.
        let filteredSubviews = self.view.subviews.filter({
            $0 is UIImageView })
        
        // Cycle through the filtered array.
        for view in filteredSubviews  {
            
            // Create a UITapGestureRecognizer for each image view, specifying the callback. This is an alternative way of adding gesture recognizers. Previously you added the recognizers to the storyboard.

            let recognizer = UITapGestureRecognizer(target: self,
                                                    action:#selector(handleTap(recognizer:)))
            
            // Set the delegate of the recognizer programatically, and add the recognizer to the image view
            recognizer.delegate = self as? UIGestureRecognizerDelegate
            view.addGestureRecognizer(recognizer)
            
            //TODO: Add a custom gesture recognizer too
            recognizer.require(toFail: monkeyPan)
            recognizer.require(toFail: bananaPam)
            
            let recognizer2 = TickleGestureRecognizer(target: self,
                                                      action:#selector(handleTickle(recognizer:)))
            recognizer2.delegate = self as? UIGestureRecognizerDelegate
            view.addGestureRecognizer(recognizer2)
        }
        self.chompPlayer = self.loadSound(filename: "chomp")
        self.hehePlayer = self.loadSound(filename: "hehehe1")

    }
    
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer) {
        
        // call translationIn to retrieve the amount the user has moved their finger
        let translation = recognizer.translation(in: self.view)
        
        // you get a reference to the monkey image view by calling recognizer.view. Makes code more generic.
        if let view = recognizer.view {
            
            // use that amount to move the center of the monkey the same amount the finger has been dragged
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        
        // set the translation back to zero when done to avoid the translation from compounding each time. your monkey will rapidly move off the screen
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == UIGestureRecognizerState.ended {
            
            // Figure out the length of the velocity vector (i.e. the magnitude)
            let velocity = recognizer.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            print("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // If the length is < 200, then decrease the base speed, otherwise increase it.
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            
            // Calculate a final point based on the velocity and the slideFactor.
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            
            // Make sure the final point is within the view’s bounds
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            // Animate the view to the final resting place.
            UIView.animate(withDuration: Double(slideFactor * 2),
                           delay: 0,
                           // 6
                options: UIViewAnimationOptions.curveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
        }
    }
    
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        
    }
    
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        self.chompPlayer?.play()
    }
    
    @objc func handleTickle(recognizer: TickleGestureRecognizer) {
        self.hehePlayer?.play()
    }
}
