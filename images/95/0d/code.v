module top_module(out, x, y, cOut, clk);output reg [7:0] out;
output reg cOut;
input [3:0] x, y;
input clk;

reg [8:0] temp;
always @(posedge clk)
begin
temp = x + y;
cOut = temp[8];
out = temp[7:0];
end
endmodule