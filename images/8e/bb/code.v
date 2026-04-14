module top_module(input clk, 
						input select, 
						input [31:0] first, 
						input [31:0] second, 
						output reg [31:0] out);always @(posedge clk)
begin

	out = select ? first : second;

end
endmodule