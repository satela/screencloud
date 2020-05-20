package
{
	import laya.display.Sprite;
	
	public class EChartItem extends Sprite
	{
		private var chartWidth:int = 100;
		private var chartHeight:int = 100;
		
		private var chartType:int = 0;//0 柱状图  1 折线图  2 饼图
		public function EChartItem()
		{
			super();
		}
	}
}