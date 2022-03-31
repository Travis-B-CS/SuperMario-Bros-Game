import Igis
import Scenes
import Foundation

class Coin : RenderableEntity {

    let coinMain : Image
    let coinSlightlyTurnedLeft : Image
    let coinMoreTurnedLeft : Image
    let coinSideways : Image
    let coinMoreTurnedRight : Image
    let coinSlightlyTurnedRight : Image
    var isActive = false
    var currentAnimationFrameCount = 0
    var rect = Rect(topLeft:Point(x:0,y:0), size:Size(width:0,height:0))

    init() {
        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }

        coinMain = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinMain.png")
        coinSlightlyTurnedLeft = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinSlightlyTurnedLeft.png")
        coinMoreTurnedLeft = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinMoreTurnedLeft.png")
        coinSideways = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinSideways.png")
        coinMoreTurnedRight = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinMoreTurnedRight.png")
        coinSlightlyTurnedRight = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/coinSlightlyTurnedRight.png")
    }

    // Setup images
    override func setup(canvasSize: Size, canvas: Canvas) {
        canvas.setup(coinMain, coinSlightlyTurnedLeft, coinMoreTurnedLeft, coinSideways, coinMoreTurnedRight, coinSlightlyTurnedRight)
    }

    override func calculate(canvasSize: Size) {
        currentAnimationFrameCount += 1
        if(currentAnimationFrameCount >= 30) {
            currentAnimationFrameCount = 0
        }
    }

    func setActive(value: Bool) {
        isActive = value
    }

    func setRect(newRect: Rect) {
        rect = newRect
    }

    override func render(canvas: Canvas) {
        if(isActive) {
            switch(currentAnimationFrameCount / 5) {
            case 0:
                if(coinMain.isReady) {
                    coinMain.renderMode = .destinationRect(rect)
                    canvas.render(coinMain)
                }
                break;
            case 1:
                if(coinSlightlyTurnedLeft.isReady) {
                    coinSlightlyTurnedLeft.renderMode = .destinationRect(rect)
                    canvas.render(coinSlightlyTurnedLeft)
                }
                break;
            case 2:
                if(coinMoreTurnedLeft.isReady) {
                    coinMoreTurnedLeft.renderMode = .destinationRect(rect)
                    canvas.render(coinMoreTurnedLeft)
                }
                break;
            case 3:
                if(coinSideways.isReady) {
                    coinSideways.renderMode = .destinationRect(rect)
                    canvas.render(coinSideways)
                }
                break;
            case 4:
                if(coinMoreTurnedRight.isReady) {
                    coinMoreTurnedRight.renderMode = .destinationRect(rect)
                    canvas.render(coinMoreTurnedRight)
                }
                break;
            case 5:
                if(coinSlightlyTurnedRight.isReady) {
                    coinSlightlyTurnedRight.renderMode = .destinationRect(rect)
                    canvas.render(coinSlightlyTurnedRight)
                }
                break;
            default:
                print("Why was this reached?")
                break;
            }
        }
    }
    
}
