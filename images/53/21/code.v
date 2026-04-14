module top_module(
   clk,
   address,
   we,
   re,
   din,
   dout
);input		clk;
input [6:0]	address;
input		we;
input		re;
input [7:0]	din;
output [7:0]	dout;
reg [7:0]	dout;






























parameter word_depth = 70; 





reg [7:0]	mem[0:word_depth-1];




   




always @(posedge clk)
   if (re) dout <= mem[address];


always @(posedge clk)
   if (we) mem[address] <= din;

endmodule