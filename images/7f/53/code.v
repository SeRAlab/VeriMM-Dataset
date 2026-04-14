module top_module(
	reset,
	Bclkx16_,
	Rx_done,
	data,
	rst,
	dis
);input reset;			
input Bclkx16_;			
input Rx_done;			
input [0:7]data;		
output reg rst;				
output reg [0:7] dis;	

always@(posedge Bclkx16_)
begin
	if(!reset)
	begin
	rst <= 1'b0;
	dis <= 8'b0;
	end
	
	else if(reset && Rx_done==1'b0)
	begin
	rst <= 1'b1;
	end
	
	else if(reset && Rx_done == 1'b1)
	begin
	dis = data;
	rst = 1'b1;
	end
end

endmodule