package
{
	import ui.DataGridViewUI;
	
	public class RankItem extends DataGridViewUI
	{
		
		public function RankItem()
		{
			super();
		}
		
		public function setData(data:*):void
		{
			if(data != null)
			{
				this.seq.text = data.seqNum;
				this.nametxt.text = data.rankname;
				this.amount.text = (data.amountNum as Number).toFixed(2);
			}
		}
	}
}