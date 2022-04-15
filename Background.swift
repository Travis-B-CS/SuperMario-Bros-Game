import Foundation
import Scenes
import Igis

  /*
     This class is responsible for rendering the background.
   */

//Cloud stuff
class Background : RenderableEntity {
    
    let floorImage : Image
    let backgroundFill : FillStyle = FillStyle(color:Color(red: 160, green: 161, blue: 254))
    var background : Rectangle
    var didGetInfo = false
    var bounds = Size(width:0,height:0)
    var time : Date
    
    func getFourZeroes(x:Int) -> String {
        var y = String(x)
        for _ in 0 ..< 4 - String(x).count {
            y = "0"+y
        }
        return y
    }
    
    func getWidthWithinBounds(x: Int, width: Int) -> Int {
        if(x > bounds.width) {return 0;}
        if(x + width <= bounds.width) {return width;}
        return width - ((x + width) - bounds.width);
    }
    
    func getHeightWithinBounds(y: Int, height: Int) -> Int {
        if(y > bounds.height) {return 0;}
        if(y + height <= bounds.height) {return height;}
        return height - ((y + height) - bounds.height);
    }
    
      
    init() {

        func getImage(url:String) -> Image { // A function for getting Images
            guard let url = URL(string:url) else {
                fatalError("Failed to create URL for "+url)
            }
            return Image(sourceURL:url)
        }
        
        floorImage = getImage(url: "https://www.codermerlin.com/users/brett-kaplan/mario/floorTile.png")
        
        background = Rectangle(rect:Rect(topLeft:Point(x:0,y:0), size:Size(width:Int.max,height:Int.max)), fillMode:.fill)
        
        time = Date()
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Background")
    }
    
    override func setup(canvasSize:Size, canvas:Canvas) {
        canvas.setup(floorImage)
    }
    
    let floorTileSize = 96

    override func render(canvas:Canvas) {            
        if let canvasSize = canvas.canvasSize, !didGetInfo {
            didGetInfo = true
            
            bounds = Size(width:canvasSize.width - 10, height: canvasSize.height - 30)
            
            background = Rectangle(rect:Rect(topLeft:Point(x:0,y:0), size:bounds), fillMode:.fill)
        }
        
        if didGetInfo && floorImage.isReady {
            // render white background
            canvas.render(FillStyle(color:Color(.white)), Rectangle(rect:Rect(topLeft:Point(x:bounds.width,y:0), size:Size(width: 10, height: bounds.height + 30)), fillMode: .fill))
            
            // Render Background:
            canvas.render(backgroundFill, background)

            // Render scores/text:
            canvas.render(FillStyle(color:Color(.white)), StrokeStyle(color:Color(.white)))
            
            var text = Text(location:Point(x:50, y:50), text:"MARIO")
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)
            
            text = Text(location:Point(x:bounds.width - 200, y:50), text:"TIME")
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)

            text = Text(location:Point(x:bounds.width - 200, y:90), text: getFourZeroes(x: Int(Date().timeIntervalSince1970 - time.timeIntervalSince1970)))
            text.font = "30pt Arial"
            text.alignment = .left
            canvas.render(text)
            
            // Render floor:
            for i in 0 ..< 100 {
                let w = getWidthWithinBounds(x: i * floorTileSize, width: floorTileSize)
                let sourceRect = Rect(topLeft:Point(x:0, y:0), size:Size(width:w, height:floorTileSize))
                let destinationRect = Rect(topLeft:Point(x:floorTileSize*i, y:bounds.height - floorTileSize), size:Size(width:w, height:floorTileSize))
                floorImage.renderMode = .sourceAndDestination(sourceRect:sourceRect, destinationRect:destinationRect)
                canvas.render(floorImage)
                if w != floorTileSize {
                    break
                }
            }
            
            
        }
    }
}
