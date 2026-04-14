module top_module(
input clk,
input [24:0] val,
output reg [4:0] avg
);integer i;

always @(posedge clk)
begin
    avg = 0;
	for(i=0;i<25;i=i+1)
	   avg = avg+val[i];
end


endmodule