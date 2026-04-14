module top_module(clk,rst,PC_in,PC_out);input clk;
input rst;
input [31:0] PC_in;
output  [31:0] PC_out;

reg [31:0]tmp;
always @(posedge clk)
begin
	if(rst)
		begin
			tmp<=0;
		end
	else
		begin
			tmp<=PC_in;
		end
	end


assign PC_out=tmp;
endmodule