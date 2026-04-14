module top_module(rst, clk, pc, newpc);input rst, clk;
input [31:0] pc;
output reg [31:0] newpc;

always@(negedge rst or posedge clk)
begin
if (!rst)
	newpc <= 0 ;
else
	newpc <= pc ;
end

endmodule