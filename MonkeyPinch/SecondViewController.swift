import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func handlePinchG(recognizer : UIPinchGestureRecognizer) {
        
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
        
    }
    
   @IBAction func handleRotateG(recognizer : UIRotationGestureRecognizer) {
        
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
        
    }
    
    
}

extension SecondViewController: UIGestureRecognizerDelegate {
    
    // tells gesture recognizer whether it is OK to recognize a gesture if another (given) recognizer has already detected a gesture
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
