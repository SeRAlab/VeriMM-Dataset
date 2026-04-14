module top_module(sel,clk,reset,a,b,out );parameter width=8;
  input        [1:0] sel ;
  input         reset,     clk;
  input        [width-1:0] a;
  input        [width-1:0] b;
  output reg   [width-1:0] out;

wire [7:0] MUX [0:3];

assign MUX[0] = a+b;
assign MUX[1] = a-b;
assign MUX[2] = a^b;
assign MUX[3] = a&b;

always@(posedge clk)
begin
if (reset)
  out<=7'b0;
  else
  out <= MUX[sel];
end
 endmodule