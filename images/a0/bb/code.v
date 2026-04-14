module top_module( clk,reset,a,b,sel,out);parameter width=32;
input [width-1:0]a,b;
input sel,clk,reset;
output reg [width-1:0] out;

always@(posedge clk)
begin
if (reset)
out=32'b0;

else if (sel)
out=b;
else
out=a;
end
endmodule