module top_module(input wire [31:0]  amem,
   output wire [31:0] a,

   input wire	      clk,
   input wire	      reset);assign a = amem;

endmodule