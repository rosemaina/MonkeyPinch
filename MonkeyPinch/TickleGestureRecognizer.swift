import UIKit

class TickleGestureRecognizer:UIGestureRecognizer {
    
    /// These are the constants that define what the gesture will need. Note that requiredTickles will be inferred as an Int, but you need to specify distanceForTickleGesture as a CGFloat. If you do not, then it will be inferred as a Double, and cause difficulties when doing calculations with CGPoints later on
    let requiredTickles = 2
    let distanceForTickleGesture:CGFloat = 25.0
    
    // possible tickle directions
    enum Direction:Int {
        case DirectionUnknown = 0
        case DirectionLeft
        case DirectionRight
    }
    
    // variables to keep track of to detect this gesture //
    
    /*
     - tickleCount:- How many times the user has switched the direction of their finger (while moving a minimum amount of points). Once the user moves their finger direction three times, you count it as a tickle gesture.
     - curTickleStart:- The point where the user started moving in this tickle. You’ll update this each time the user switches direction (while moving a minimum amount of points).
     - lastDirection:- The last direction the finger was moving. It will start out as unknown, and after the user moves a minimum amount you’ll check whether they’ve gone left or right and update this appropriately.
     */
    
    var tickleCount:Int = 0
    var curTickleStart:CGPoint = CGPoint.zero
    var lastDirection:Direction = .DirectionUnknown
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            self.curTickleStart = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let ticklePoint = touch.location(in: self.view)
            
            let moveAmt = ticklePoint.x - curTickleStart.x
            var curDirection:Direction
            if moveAmt < 0 {
                curDirection = .DirectionLeft
            } else {
                curDirection = .DirectionRight
            }
            
            //moveAmt is a Float, so self.distanceForTickleGesture needs to be a Float also
            if abs(moveAmt) < self.distanceForTickleGesture {
                return
            }
            
            if self.lastDirection == .DirectionUnknown ||
                (self.lastDirection == .DirectionLeft && curDirection == .DirectionRight) ||
                (self.lastDirection == .DirectionRight && curDirection == .DirectionLeft) {
                self.tickleCount += 1
                self.curTickleStart = ticklePoint
                self.lastDirection = curDirection
                
                if self.state == .possible && self.tickleCount > self.requiredTickles {
                    self.state = .ended
                }
            }
        }
    }
    
    override func reset() {
        self.tickleCount = 0
        self.curTickleStart = CGPoint.zero
        self.lastDirection = .DirectionUnknown
        if self.state == .possible {
            self.state = .failed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        self.reset()
    }

}

