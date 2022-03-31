import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel : Int
    var interactionLayer : InteractionLayer?
    
    init(mario:Mario) {
        marioSprite = mario
        currentLevel = 0
    }

    override func calculate(canvasSize: Size) {
        
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func levelOne(canvasSize:Size) {
        if let interactionLayer = interactionLayer {
            let coin = Coin()
            coin.setRect(newRect: Rect(topLeft:Point(x:canvasSize.width / 2, y:canvasSize.height - 96 - 96 - 30), size:Size(width:96,height:96)))
            coin.setActive(value: true)
            interactionLayer.renderCoin(coin: coin)
        }
    }

    func levelTwo() {
    }

    func levelThree() {
    }

    func levelFour() {
    }

    func levelFive() {
    }

    func levelSix() {
    }

    func levelSeven() {
    }

    func levelEight() {
    }

    func levelNine() {
    }

    func levelTen() {
    }
}
