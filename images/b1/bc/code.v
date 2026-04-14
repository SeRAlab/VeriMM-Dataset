module top_module(dout, din, ld, clk);input [15:0] din;
   input ld, clk;
   output reg [15:0] dout;
   
   always @ (posedge clk)
      if (ld) dout <= din;endmodule