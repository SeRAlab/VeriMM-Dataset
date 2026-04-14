module Phy_sim (
input			Gtx_clk					,
output			Rx_clk					,
output			Tx_clk					,
input			Tx_er					,
input			Tx_en					,
input	[7:0]	Txd						,
output			Rx_er					,
output			Rx_dv					,
output 	[7:0]	Rxd						,
output			Crs						,
output			Col						,
input	[2:0]	Speed				
);
reg				Clk_25m			;
reg				Clk_2_5m		;
always 
	begin
	#20		Clk_25m=0;
	#20		Clk_25m=1;
	end
always  
	begin
	#200	Clk_2_5m=0;
	#200	Clk_2_5m=1;
	end   
assign 	Rx_clk=Speed[2]?Gtx_clk:Speed[1]?Clk_25m:Speed[0]?Clk_2_5m:0;        
assign 	Tx_clk=Speed[2]?Gtx_clk:Speed[1]?Clk_25m:Speed[0]?Clk_2_5m:0;
assign	Rx_dv	=Tx_en	;
assign	Rxd		=Txd	;
assign	Rx_er	=0		;
assign	Crs    	=Tx_en	;
assign  Col		=0		;
endmodule