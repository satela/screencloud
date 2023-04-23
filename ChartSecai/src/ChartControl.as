package
{
	import HttpRequestUtil;
	
	import laya.components.Script;
	import laya.events.Event;
	import laya.maths.Point;
	import laya.utils.Browser;
	import laya.utils.Handler;
	
	import ui.ChartViewUI;

	public class ChartControl extends Script
	{
		private var uiSkin:ChartViewUI;
		
		private var materialChart:*;
		
		private var monthChart:*;
		
		private var dayChart:*;
		
		private var dayHourChart:*;
		
		private var manufactureRankItems:Vector.<RankItem>;
		private var lastManuNum:int = 1;
		public function ChartControl()
		{
		}
		
		override public function onStart():void
		{
			uiSkin = this.owner as ChartViewUI;
			
			uiSkin.areaList.itemRender = RankItem;
			
			//uiSkin.applylist.vScrollBarSkin = "";
			uiSkin.areaList.repeatX = 1;
			uiSkin.areaList.spaceY = 0;
			
			uiSkin.areaList.renderHandler = new Handler(this, updateAreaList);
			uiSkin.areaList.selectEnable = false;
			
			uiSkin.areaList.array = [];
			
//			uiSkin.outputlist.itemRender = RankItem;
//			
//			//uiSkin.applylist.vScrollBarSkin = "";
//			uiSkin.outputlist.repeatX = 1;
//			uiSkin.outputlist.spaceY = 0;
//			
//			uiSkin.outputlist.renderHandler = new Handler(this, updateAreaList);
//			uiSkin.outputlist.selectEnable = false;
			
			uiSkin.areaList.array = [];
			manufactureRankItems = new Vector.<RankItem>();
			for(var i:int=0;i < 40;i++)
			{
				manufactureRankItems.push(new RankItem());
				manufactureRankItems[i].y = 28*i;
				manufactureRankItems[i].visible = false;
				uiSkin.manufacturePanel.addChild(manufactureRankItems[i]);
			}
			uiSkin.maskimg.visible = false;
	//		uiSkin.outputlist.array = [];
			//HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getGroupChartData,this,onGetGroupData,null,"post");

			//uiSkin.toplabel.on(Event.DOUBLE_CLICK,this,onrefresh);
			Laya.timer.loop(1000,this,updateTime);
			updateTime();
			Laya.timer.once(2000,this,initChatDiv);
			//Laya.timer.loop(10000,this,initChatDiv);

		}
		
		private function onrefresh():void
		{
			getTodayOrders();
			getMonthOrders();
			getTenDyasOrders();
			getCurMonthOrders();
		}
		
		private function updateDateInputPos():void
		{
			
		}
		
		private function initChatDiv():void{
			
			//var groupdata:Object = JSON.parse(data);
			
			var echart = Browser.window.echarts;
			
			
		
			var chartdiv = Browser.document.createElement("div");
			
			chartdiv.style="filter:alpha(opacity=100);opacity:100;width: 650;height:780px;left:0;top:320";
			
			chartdiv.style.width = 650/(Browser.pixelRatio) + 10;
			chartdiv.style.height = 350/(Browser.pixelRatio) + 80;

			//var pt:Point = uiSkin.materialBox.localToGlobal(new Point(uiSkin.materialBox.x,uiSkin.materialBox.y),true);
			
			//chartdiv.style.top = (pt.y + 4) + "px";
			//chartdiv.style.left = (pt.x - 50) +  "px";
			
			//			if(param && param.type == "License")
			//				file.multiple="";
			//			else
			
			chartdiv.style.position ="absolute";
			chartdiv.style.zIndex = 999;
			Browser.document.body.appendChild(chartdiv);//添加到舞台
			
			materialChart = echart.init(chartdiv);
			
			
			var chartdivMonth = Browser.document.createElement("div");
			
			chartdivMonth.style="filter:alpha(opacity=100);opacity:100;width: 650;height:230px;left:620;top:88";
			
			chartdivMonth.style.width = 650/(Browser.pixelRatio) + 20;
			//chartdivMonth.style.height = 270/(Browser.pixelRatio);
			
//			 pt = uiSkin.monthBox.localToGlobal(new Point(uiSkin.monthBox.x,uiSkin.monthBox.y),true);
//			
//			chartdivMonth.style.top = (pt.y + 4) + "px";
//			chartdivMonth.style.left = (pt.x - 26) +  "px";
			
			//			if(param && param.type == "License")
			//				file.multiple="";
			//			else
			
			chartdivMonth.style.position ="absolute";
			chartdivMonth.style.zIndex = 999;
			Browser.document.body.appendChild(chartdivMonth);//添加到舞台
			
			monthChart = echart.init(chartdivMonth);
			
			
			var chartdivDay = Browser.document.createElement("div");
			
			chartdivDay.style="filter:alpha(opacity=100);opacity:100;width: 600;height:200;left:620;top:250";
			chartdivDay.style.width = 650/(Browser.pixelRatio) + 20;
			//chartdivDay.style.height = 270/(Browser.pixelRatio);
			

			
			chartdivDay.style.position ="absolute";
			chartdivDay.style.zIndex = 999;
			Browser.document.body.appendChild(chartdivDay);//添加到舞台
			
			dayChart = echart.init(chartdivDay);
			
			
			var chartdivHour = Browser.document.createElement("div");
			
			chartdivHour.style="filter:alpha(opacity=100);opacity:100;width: 600;height:200;left:620;top:380";
			chartdivHour.style.width = 650/(Browser.pixelRatio) + 20;
			//chartdivHour.style.height = 270/(Browser.pixelRatio);
			
//			pt = uiSkin.hourBox.localToGlobal(new Point(uiSkin.hourBox.x,uiSkin.hourBox.y),true);
//			
//			chartdivHour.style.top = (pt.y + 4) + "px";
//			chartdivHour.style.left = (pt.x - 26) +  "px";
			
			//			if(param && param.type == "License")
			//				file.multiple="";
			//			else
			
			chartdivHour.style.position ="absolute";
			chartdivHour.style.zIndex = 999;
			Browser.document.body.appendChild(chartdivHour);//添加到舞台
			
			dayHourChart = echart.init(chartdivHour);
			
			//var materialname:String = "城铁（299）可以";
			//var reg:RegExp =  '\（.+?\）';
			//materialname = (materialname as String).replace(reg,"");
			//console.log(materialname);
			
			//Browser.window.freshBarChart(monthChart,["户外高清写真","01-03","01-04","01-05","01-06"],[120,210,350,400,800],"月度销售额");
			//Browser.window.freshBarChart(dayChart,["户外高清写真","01-03","01-04","01-05","01-06"],[120,210,350,400,800],"日销售额");


			//Browser.window.freshChart(materialChart,[120,210,350,400,800],["户外高清写真","户外高清","户外高清写真","户外高清写真","户外高清写真"]);
			
			//Browser.window.freshZheChart(dayHourChart,["户外高清写真","01-03","01-04","01-05","01-06"],[120,210,350,400,800]);
			
			//groupdata.xaxisList = [120,210,350,400,800];
			//groupdata.yaxisList = ["户外高清写真","01-03","01-04","01-05","01-06"];
			Laya.timer.loop(30000,this,getTodayOrders);
			getTodayOrders();
			//Laya.timer.loop(6000000,this,getMonthOrders);
			Laya.timer.loop(10000,this,getMonthOrders);
			getMonthOrders();
			
			Laya.timer.loop(300000,this,getTenDyasOrders);
			getTenDyasOrders();
			
			Laya.timer.loop(7200000,this,getCurMonthOrders);
			getCurMonthOrders();
			
			Laya.timer.loop(50,this,scrollRank);

			//Browser.window.getChartData();
			
		}
		private function onGetTopDataBack(data:*):void
		{
			var orderdata:Object = JSON.parse(data);
			uiSkin.newgroup.text =  parseInt(orderdata.newGroup).toString();
			
			uiSkin.todayOrderAmount.text = (orderdata.amount as Number).toFixed(2);
			
			uiSkin.todayOrderNun.text = parseInt(orderdata.num).toString();
			
			uiSkin.monthyOrderAmount.text = (orderdata.monthamount as Number).toFixed(2);

		}
		
		private function getMonthOrders():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getMonthOrdersData,this,onGetMonthOrdersData,null,"post");

		}
		
		private function onGetMonthOrdersData(data:*):void
		{
			var orderdata:Object = JSON.parse(data);
			for(var i:int=0;i < orderdata.yaxisList.length;i++)
			{
				var num:Number = orderdata.yaxisList[i]/10000;
				orderdata.yaxisList[i] = parseFloat((num.toFixed(4)));
			}
			Browser.window.freshBarChart(monthChart,orderdata.xaxisList,orderdata.yaxisList,"月度销售额");
						
		}
		
		private function getTenDyasOrders():void
		{
			
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getTenDaysOrdersData,this,onGetTenDaysOrdersData,null,"post");
			
		}
		
		private function onGetTenDaysOrdersData(data:*):void
		{
			var orderdata:Object = JSON.parse(data);
			for(var i:int=0;i < orderdata.yaxisList.length;i++)
			{
				var num:Number = orderdata.yaxisList[i]/10000;
				orderdata.yaxisList[i] = parseFloat((num.toFixed(4)));
			}
			Browser.window.freshBarChart(dayChart,orderdata.xaxisList,orderdata.yaxisList,"十日单日销售额");
			
		}
		
		private function getTodayOrders():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getTodayOrderData,this,onOrdersback,null,"post");
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getTodayDataUrl,this,onGetTopDataBack,null,"post");
			
		}
		
		private function getCurMonthOrders():void
		{
			HttpRequestUtil.instance.Request(HttpRequestUtil.httpUrl + HttpRequestUtil.getCurMonthOrdersData,this,onGetCurMonthOrdersBack,null,"post");
			
		}
		
		private function onGetCurMonthOrdersBack(data:*):void
		{
			//var orderdata:Object = JSON.parse(data);
			//console.log(orderdata.length);
			
			var materialrank:Object = JSON.parse(data);
			
			
			
			
//			for(var i:int=0;i < orderdata.length;i++)
//			{
//				try
//				{
//					var orderinfo:Object = JSON.parse(orderdata[i].orText);
//					
//					
//					var proitemlist:Array = orderinfo.orderItemList;
//					for(var j:int=0;j < proitemlist.length;j++)
//					{
//						var prod:Object = proitemlist[j];
//						if(materialrank.hasOwnProperty(prod.prod_name))
//							materialrank[prod.prod_name] += parseFloat(prod.item_priceStr)*prod.item_number;
//						else
//							materialrank[prod.prod_name] = parseFloat(prod.item_priceStr)*prod.item_number;
//					}
//				}
//				catch(err:Error)
//				{
//					
//				}
//				
//			}
						
			
			var materialRank:Array = [];
			for(var materialname in materialrank)
			{
				var reg:RegExp = /（.+?）/g;
				var tempobj = {};
				tempobj.amountNum = materialrank[materialname]/10000;
				
				materialname = materialname.replace(reg,"");
				materialname = (materialname as String).substring(0,6);
				tempobj.rankname = materialname;
				
				materialRank.push(tempobj);
			}
			
			materialRank.sort(compareAmount);
			
			while(materialRank.length > 10)
			{
				materialRank.splice(materialRank.length - 1,1);
			}
			
			var xlist:Array = [];
			var ylist:Array = [];
			for(var i:int=0;i < materialRank.length;i++)
			{
				xlist.push(materialRank[i].rankname);
				ylist.push((parseFloat(materialRank[i].amountNum)));
			}
			xlist.reverse();
			ylist.reverse();
			Browser.window.freshChart(materialChart,ylist,xlist);
			
			
		}
		
		private function onOrdersback(data:*):void
		{
			var orderdata:Object = JSON.parse(data);
			console.log(orderdata.length);
			var areadata:Object = {};
			
			var outputrank:Object = {};
			//var materialrank:Object = {};

			var daygesture:Array = new Array(24);
			var hours:Array = [];
			
			var manufactureNameDic:Object = {};
			for(var i:int=0;i < 24;i++)
			{
				daygesture[i] = 0;
				if(i < 10)
					hours.push("0"+i);
				else
					hours.push(i+"");
			}
			
			for(var i:int=0;i < orderdata.length;i++)
			{
				try
				{
					var orderinfo:Object = JSON.parse(orderdata[i].orText);
					var address:String = orderinfo.address;
					var province:String = address.split(" ")[0];
					if(areadata.hasOwnProperty(province))
					{
						areadata[province] += parseFloat(orderinfo.money_paidStr);
					}
					else
					{
						areadata[province] = parseFloat(orderinfo.money_paidStr);
					}
					
					var outputcenter:String = orderinfo.manufacturer_code;
					if(outputrank.hasOwnProperty(outputcenter))
					{
						outputrank[outputcenter] += parseFloat(orderinfo.money_paidStr);
					}
					else
					{
						outputrank[outputcenter] = parseFloat(orderinfo.money_paidStr);
						manufactureNameDic[orderinfo.manufacturer_code] = orderinfo.manufacturer_name;
					}
					
					var ordertime:String = orderdata[i].orDate.split(" ")[1].split(":")[0];
					
					var hour:int = parseInt(ordertime);
					//console.log("下单小时:" + hour);
					daygesture[hour] += orderdata[i].orAmount;
					
//					var proitemlist:Array = orderinfo.orderItemList;
//					for(var j:int=0;j < proitemlist.length;j++)
//					{
//						var prod:Object = proitemlist[j];
//						if(materialrank.hasOwnProperty(prod.prod_name))
//							materialrank[prod.prod_name] += parseFloat(prod.item_priceStr)*prod.item_number;
//						else
//							materialrank[prod.prod_name] = parseFloat(prod.item_priceStr)*prod.item_number;
//					}
				}
				catch(err:Error)
				{
					
				}
								
			}
			
			var areaRank:Array = [];
			for(var areaname in areadata)
			{
				areaRank.push({"rankname":areaname,"amountNum":areadata[areaname]});
			}
			
			areaRank.sort(compareAmount);
			while(areaRank.length > 10)
			{
				areaRank.splice(areaRank.length - 1,1);
			}
			for(var i:int=0;i < areaRank.length;i++)
			{
				areaRank[i].seqNum = (i+1);
			}
			
			uiSkin.areaList.array = areaRank;
			
			var manufactRank:Array = [];
			for(var manucode in outputrank)
			{
				manufactRank.push({"rankname":manufactureNameDic[manucode],"amountNum":outputrank[manucode]});
			}
			
			manufactRank.sort(compareAmount);
			
//			while(manufactRank.length > 10)
//			{
//				manufactRank.splice(manufactRank.length - 1,1);
//			}
			
			for(var i:int=0;i < manufactRank.length;i++)
			{
				manufactRank[i].seqNum = (i+1);
			}
			
			//uiSkin.outputlist.array = manufactRank;
			if(manufactRank.length > 0)
			{
				var addnum:int = manufactRank.length - lastManuNum;
				var thebottomPos:Number = manufactureRankItems[lastManuNum - 1].y;
				for(var i:int=lastManuNum;i < lastManuNum + addnum;i++)
				{
					if(i < manufactureRankItems.length)
					{
						manufactureRankItems[i].y = manufactureRankItems[i - 1].y + 28;
					}
				}
				for(var i:int=0;i < lastManuNum;i++)
				{
					if(manufactureRankItems[i].y > thebottomPos)
					{
						manufactureRankItems[i].y += 28 * addnum;
					}
				}
				for(var i:int=0;i < manufactureRankItems.length;i++)		
				{
					if(i < manufactRank.length)
					{
						manufactureRankItems[i].setData(manufactRank[i]);
						manufactureRankItems[i].visible = true;
					}
					else
						manufactureRankItems[i].visible = false;

				}
				
			}
			if(manufactRank.length <= 26)
			{
				for(var i:int=0;i < manufactureRankItems.length;i++)
					manufactureRankItems[i].y = 28*i;
			}
			
			lastManuNum = manufactRank.length;
			
//			var materialRank:Array = [];
//			for(var materialname in materialrank)
//			{
//				var reg:RegExp = /（.+?）/g;
//				var tempobj = {};
//				tempobj.amountNum = materialrank[materialname]/10000;
//				
//				materialname = materialname.replace(reg,"");
//				materialname = (materialname as String).substring(0,6);
//				tempobj.rankname = materialname;
//				
//				materialRank.push(tempobj);
//			}
//			
//			materialRank.sort(compareAmount);
//			
//			while(materialRank.length > 10)
//			{
//				materialRank.splice(materialRank.length - 1,1);
//			}
//			
//			var xlist:Array = [];
//			var ylist:Array = [];
//			for(var i:int=0;i < materialRank.length;i++)
//			{
//				xlist.push(materialRank[i].rankname);
//				ylist.push((parseFloat(materialRank[i].amountNum as Number)));
//			}
//			xlist.reverse();
//			ylist.reverse();
//			Browser.window.freshChart(materialChart,ylist,xlist);

			for(var i:int=0;i < daygesture.length;i++)
				daygesture[i] /= 10000;
			Browser.window.freshZheChart(dayHourChart,hours,daygesture);
		}
		
		private function scrollRank():void
		{
			if(lastManuNum > 26)
			{
				for(var i:int=0;i < lastManuNum;i++)
				{
					if(manufactureRankItems[i].y - 1 <= -28)
					{
						manufactureRankItems[i].y = 28 * (lastManuNum-1);
					}
					else
						manufactureRankItems[i].y = manufactureRankItems[i].y -1;
				}
			}
		}
		
		private function updateTime():void
		{
			var fulltime:String = UtilTool.formatFullDateTime(new Date());
			this.uiSkin.datetxt.text = fulltime.split(" ")[0];
			this.uiSkin.timetxt.text = fulltime.split(" ")[1];

		}
		
		private function compareAmount(a:*,b:*):int
		{
			if(a.amountNum > b.amountNum)
				return -1;
			else if(a.amountNum < b.amountNum)
				return 1;
			else
				return 0;
		}
		private function updateAreaList(cell:RankItem,index:int):void
		{
			cell.setData(cell.dataSource);
		}
	}
}