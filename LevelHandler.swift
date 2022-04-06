import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel = 1
    var interactionLayer : InteractionLayer?
    var score = 0
    var activeEntities : [RenderableEntity] = [];
    
    init(mario:Mario) {
        marioSprite = mario

        super.init(name: "LevelHandler")

        marioSprite.setLevelHandler(handler: self)
    }

    func getFourZeroes(x:Int) -> String {
        var y = String(x)
        for _ in 0 ..< 4 - String(x).count {
            y = "0"+y
        }
        return y
    }

    override func calculate(canvasSize: Size) {
        if(marioSprite.topLeft.x + marioSprite.marioSize.width > marioSprite.cSize.width + 10) {
            clearLevel()

            currentLevel += 1
            score += 3
            
            switch(currentLevel) {
            case 1:
                levelOne(canvasSize: canvasSize)
            case 2:
                levelTwo(canvasSize: canvasSize)
            case 3:
                levelThree(canvasSize: canvasSize)
            case 4:
                levelFour(canvasSize: canvasSize)
            case 5:
                levelFive(canvasSize: canvasSize)
            default:
                print("You reached the end!")
            }
        }
    }

    override func render(canvas: Canvas) {
        let text = Text(location:Point(x:50, y:90), text:getFourZeroes(x:score))
        text.font = "30pt Arial"
        canvas.render(text)
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func setScore(value: Int) {
        score = value
    }

    func clearLevel() {
        for entity in activeEntities {
            if let interactionLayer = interactionLayer {                
                interactionLayer.removeEntity(entity:entity)
            }
        }
        marioSprite.setGoombas(tiles: [])
        marioSprite.setBoxes(tiles: [])
        marioSprite.setCoins(tiles: [])
        activeEntities = []

        marioSprite.topLeft = Point(x:10, y:marioSprite.topLeft.y)
    }

    func levelOne(canvasSize:Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            coin.setActive(value: false)
            
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 400, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 600, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)

            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile])

            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin])
        }
    }

    func levelTwo(canvasSize: Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 3, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            coin.setActive(value: false)
            
            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            let questionTile2 = QuestionBlockTile(whatInside:"coin")
            questionTile2.setTopLeft(point: Point(x: canvasSize.width / 2 + 100, y: canvasSize.height - 200 - 96 - 100))
            let coin2 = Coin()
            coin2.setRect(newRect: questionTile2.rect)
            coin2.setActive(value: false)
             
            questionTile2.setInsideCoin(value: coin2)
            questionTile2.setLevelHandler(handler: self)
                        
            let groundCoin = Coin()
            groundCoin.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 - 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin.setActive(value: true)

            let groundCoin2 = Coin()
            groundCoin2.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin2.setActive(value: true)
            
            let groundCoin3 = Coin()
            groundCoin3.setRect(newRect: Rect(topLeft:Point(x: canvasSize.width / 2 + 200, y: canvasSize.height - 50 - 96 - 100), size:Size(width: 96, height: 96)))
            groundCoin3.setActive(value: true)

            let goomba = Goomba()
            goomba.setTopLeft(value: Point(x: canvasSize.width / 2 + 300, y: canvasSize.height - 96 - 96 - 30))
            goomba.setVelocityX(value: 2)

            interactionLayer.renderGoomba(goomba: goomba)
            interactionLayer.renderCoin(coin: groundCoin)
            interactionLayer.renderCoin(coin: groundCoin2)
            interactionLayer.renderCoin(coin: groundCoin3)
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderCoin(coin: coin2)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile2)
            
            marioSprite.setCoins(tiles: [groundCoin, groundCoin2, groundCoin3])
            marioSprite.setBoxes(tiles: [questionTile, questionTile2])
            marioSprite.setGoombas(tiles: [goomba])

            activeEntities.append(contentsOf:[groundCoin, groundCoin2, groundCoin3, questionTile, coin, questionTile2, coin2, goomba])
        }

    }

    func levelThree(canvasSize: Size) {
        
    }

    func levelFour(canvasSize: Size) {
    }

    func levelFive(canvasSize: Size) {
    }

    func levelSix(canvasSize: Size) {
    }

    func levelSeven(canvasSize: Size) {
    }

    func levelEight(canvasSize: Size) {
    }

    func levelNine(canvasSize: Size) {
    }

    func levelTen(canvasSize: Size) {
    }
}
