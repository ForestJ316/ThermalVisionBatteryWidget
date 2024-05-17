package {
	
	import flash.display.MovieClip;
	
	import hudframework.IHUDWidget;
	
	public class Main extends MovieClip implements IHUDWidget
	{	
		private static const WIDGET_IDENTIFIER:String = "Battery_Widget.swf";
		
		private var OriginalWidth:Number;
		private var OriginalHeight:Number;
		
		private static const PosTopLeft:String = "TopLeft"
		private static const PosTopRight:String = "TopRight"
		private static const PosBottomRight:String = "BottomRight"
		private static const PosBottomLeft:String = "BottomLeft"
		
		private static const Command_UpdateBattery:int = 100;
		private static const Command_ScaleBattery:int = 200;
		private static const Command_SetBatteryPos:int = 300;
		
		private static const Status100:String = "Battery100";
		private static const Status95:String = "Battery95";
		private static const Status90:String = "Battery90";
		private static const Status85:String = "Battery85";
		private static const Status80:String = "Battery80";
		private static const Status75:String = "Battery75";
		private static const Status70:String = "Battery70";
		private static const Status65:String = "Battery65";
		private static const Status60:String = "Battery60";
		private static const Status55:String = "Battery55";
		private static const Status50:String = "Battery50";
		private static const Status45:String = "Battery45";
		private static const Status40:String = "Battery40";
		private static const Status35:String = "Battery35";
		private static const Status30:String = "Battery30";
		private static const Status25:String = "Battery25";
		private static const Status20:String = "Battery20";
		private static const Status15:String = "Battery15";
		private static const Status10:String = "Battery10";
		private static const Status5:String = "Battery5";
		private static const Status0:String = "Battery0";
		private static const StatusEmptyAnim:String = "BatteryEmptyAnim";
				
		public function Main()
		{
			OriginalWidth = this.BatteryMovie.width;
			OriginalHeight = this.BatteryMovie.height;
		}
		
		public function processMessage(command:String, params:Array):void
		{
			switch(command)
			{
				case String(Command_UpdateBattery):
					var BatteryHealth:String = String(params[0]);
					switch(BatteryHealth)
					{
						case String(Status100):
							this.BatteryMovie.gotoAndStop(Status100);
							break;
						case String(Status95):
							this.BatteryMovie.gotoAndStop(Status95);
							break;
						case String(Status90):
							this.BatteryMovie.gotoAndStop(Status90);
							break;
						case String(Status85):
							this.BatteryMovie.gotoAndStop(Status85);
							break;
						case String(Status80):
							this.BatteryMovie.gotoAndStop(Status80);
							break;
						case String(Status75):
							this.BatteryMovie.gotoAndStop(Status75);
							break;
						case String(Status70):
							this.BatteryMovie.gotoAndStop(Status70);
							break;
						case String(Status65):
							this.BatteryMovie.gotoAndStop(Status65);
							break;
						case String(Status60):
							this.BatteryMovie.gotoAndStop(Status60);
							break;
						case String(Status55):
							this.BatteryMovie.gotoAndStop(Status55);
							break;
						case String(Status50):
							this.BatteryMovie.gotoAndStop(Status50);
							break;
						case String(Status45):
							this.BatteryMovie.gotoAndStop(Status45);
							break;
						case String(Status40):
							this.BatteryMovie.gotoAndStop(Status40);
							break;
						case String(Status35):
							this.BatteryMovie.gotoAndStop(Status35);
							break;
						case String(Status30):
							this.BatteryMovie.gotoAndStop(Status30);
							break;
						case String(Status25):
							this.BatteryMovie.gotoAndStop(Status25);
							break;
						case String(Status20):
							this.BatteryMovie.gotoAndStop(Status20);
							break;
						case String(Status15):
							this.BatteryMovie.gotoAndStop(Status15);
							break;
						case String(Status10):
							this.BatteryMovie.gotoAndStop(Status10);
							break;
						case String(Status5):
							this.BatteryMovie.gotoAndStop(Status5);
							break;
						case String(Status0):
							this.BatteryMovie.gotoAndStop(Status0);
							break;
						case String(StatusEmptyAnim):
							this.BatteryMovie.gotoAndPlay(StatusEmptyAnim);
							break;
					}
				case String(Command_ScaleBattery):
					this.BatteryMovie.width = OriginalWidth * Number(params[0]);
					this.BatteryMovie.height = OriginalHeight * Number(params[1]);
					break;
				case String(Command_SetBatteryPos):
					var MainPos:String = String(params[0]);
					switch(MainPos)
					{
						case String(PosTopLeft):
							this.BatteryMovie.x = 40;
							this.BatteryMovie.y = 25;
							break;
						case String(PosTopRight):
							this.BatteryMovie.x = 1210;
							this.BatteryMovie.y = 25;
							break;
						case String(PosBottomRight):
							this.BatteryMovie.x = 1210;
							this.BatteryMovie.y = 520;
							break;
						case String(PosBottomLeft):
							this.BatteryMovie.x = 40;
							this.BatteryMovie.y = 520;
							break;
					}
			}
		}
	}
}
