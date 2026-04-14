module top_module(clk,bin,dec0,dec1,dec2);input clk;
input [7:0] bin;
output reg [3:0] dec0;
output reg [3:0] dec1;
output reg [3:0] dec2;
reg [3:0] i;
always @(posedge clk)
begin
	for(i=0;i<=9;i=i+1)
	begin
		if(100*i<=bin) dec2=i;
	end
	for(i=0;i<=9;i=i+1)
	begin
		if(10*i<=bin-dec2*100) dec1=i;
	end
	dec0=bin-dec1*10-dec2*100;
end
endmodule