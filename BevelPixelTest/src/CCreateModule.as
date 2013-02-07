package 
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.Timer;
    import org.flixel.FlxButton;
    import org.flixel.FlxG;
    import org.flixel.FlxObject;
    import org.flixel.FlxSound;
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.FlxTileblock;
    import org.flixel.FlxU;
    import org.flixel.plugin.photonstorm.FlxControl;
    import org.flixel.plugin.photonstorm.FlxControlHandler;
    
    public class CCreateModule extends FlxState
    {
        [Embed(source="../bin/assets/TV.png")]
        private static const BMP_TV:Class;
        [Embed(source="../bin/assets/Door.png")]
        private static const BMP_DOOR:Class;
        [Embed(source="../bin/assets/FishPic.PNG")]
        private static const BMP_FISH:Class;
        [Embed(source="../bin/assets/Hanger-BIG.png")]
        private static const BMP_BIG_HANGER:Class;
        [Embed(source="../bin/assets/Hanger-Small.PNG")]
        private static const BMP_SMALL_HANGER:Class;
        [Embed(source="../bin/assets/PlayerAnim.PNG")]
        private static const BMP_PLAYER:Class;
        [Embed(source="../bin/assets/RightStep.mp3")]
        private static const SNE_STEP:Class;
        
        private var m_sprPlayer:FlxSprite
        private var m_tileFloor:FlxTileblock;
        
        private var m_bmpBevel:Bitmap;
        
        public override function create() : void
        {
            Initial();
        }
        
        //初始化必須的資源
        private function Initial() : void
        {
            if (FlxG.getPlugin(FlxControl) == null)
            {
                FlxG.addPlugin(new FlxControl());
            }
            
            FlxG.bgColor = 0XFF999999;
            
            //Floor-------------------------------------------------------------------
            m_tileFloor = new FlxTileblock(0, 90, 100, 50);
            m_tileFloor.makeGraphic(320, 32, 0xFF689C16);
            this.add(m_tileFloor);
            
            //Misc
            var spr:FlxSprite = new FlxSprite(20, 50);
            spr.loadGraphic(BMP_FISH, true, false, 16, 16);
            spr.addAnimation("idle", [0], 0, false);
            spr.play("idle");
            this.add(spr);
            
            spr = new FlxSprite(120, 60);
            spr.loadGraphic(BMP_DOOR, true, false, 32, 32);
            spr.addAnimation("idle", [0], 0, false);
            spr.play("idle");
            this.add(spr);
            
            spr = new FlxSprite(60, 68, BMP_BIG_HANGER);
            this.add(spr);
            
            spr = new FlxSprite(150, 70, BMP_TV);
            this.add(spr);
            
            spr = new FlxSprite(90, 70, BMP_SMALL_HANGER);
            this.add(spr);
            
            //Player--------------------------------------------------------------
            m_sprPlayer = new FlxSprite(10, 60);
            m_sprPlayer.loadGraphic(BMP_PLAYER, true, true, 16, 20);
            m_sprPlayer.addAnimation("idle", [3], 0, false);
            m_sprPlayer.play("idle");
            m_sprPlayer.offset.y = -8;
            
            FlxControl.create(m_sprPlayer, FlxControlHandler.MOVEMENT_ACCELERATES, 
                              FlxControlHandler.STOPPING_DECELERATES, 1, true, false);
            
            var control:FlxControlHandler = FlxControl.player1;
            control.setWASDControl(false, false, true, true);
			control.setCursorControl(false, false, true, true);
            control.setMovementSpeed(150, 0, 150, 100, 100, 0);
			control.setDeceleration(2000, 500);
			control.setGravity(0, 500);
            control.setBounds(0, 0, FlxG.width, FlxG.height);
			control.setJumpButton("SPACE", FlxControlHandler.KEYMODE_PRESSED, 200, 
                                  FlxObject.FLOOR, 250, 200);
                                  
			var sndStep:FlxSound = new FlxSound();
            sndStep.loadEmbedded(SNE_STEP);
            control.setSounds(null, null, sndStep);
            
            this.add(m_sprPlayer);
            
            //Create Bevel pixels bitmap
            const WIDTH:Number = FlxG.width;
            const HEIGHT:Number = FlxG.height;
            var bd:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0X808080);
            
            var uiColor:uint;
            for (var uiX:uint = 0; uiX < WIDTH; uiX++)
            {
                for (var uiY:uint = 0; uiY < HEIGHT; uiY++)
                {
                    var uiRemainderX:uint = uiX%3;
                    var uiRemainderY:uint = uiY%3;
                    
                    uiColor = this.getBevelColor(uiRemainderX , uiRemainderY);
                    bd.setPixel(uiX, uiY, uiColor);
                }
            }

            m_bmpBevel = new Bitmap(bd);
            m_bmpBevel.x = -WIDTH/2;
            m_bmpBevel.y = -HEIGHT/2;
            m_bmpBevel.blendMode = BlendMode.OVERLAY;
            
            //add Btn
            var btn:FlxButton = new FlxButton(0, 0, "On/Off",
            function () : void
            {
                var sprContainer:Sprite = FlxG.camera.getContainerSprite();
                if (sprContainer.contains(m_bmpBevel))
                {
                    sprContainer.removeChild(m_bmpBevel);
                    return;
                }
                
                sprContainer.addChild(m_bmpBevel);
            });
            
            this.add(btn);
        }
        
        public override function update():void 
        {
            super.update();
            
            FlxG.collide(m_sprPlayer, m_tileFloor);
        }
        
        public override function draw():void 
        {
            super.draw();
        }
        
        // ----------------
        // | FF | E0 | E0 |
        // ----------------
        // | FF | FF | 00 |
        // ----------------
        // | FF | 00 | 00 |
        // ----------------
        // ↑ The unit Bevel pixels at "Atomic Creep Spawner"
        
        // use the uiRemainderX and uiRemainderY to get the Color
        private function getBevelColor(uiRemainderX:uint, uiRemainderY:uint) : uint
        {
            if (uiRemainderX == 0)
            {
                //return 0XFFFFFF;
                return 0X808080;
            }
            
            if (uiRemainderY == 0)
            {
                //return 0XE0E0E0;
                return 0X606060
            }
            
            if (uiRemainderY == 2)
            {
                //return 0X000000;
                return 0X404040;
            }
            
            if (uiRemainderX == 1)
            {
                //return 0XFFFFFF;
                return 0X808080;
            }
            
            if (uiRemainderX == 2)
            {
                //return 0X000000;
                return 0X404040;
            }
            
            return 0X808080;
        }
    }
}