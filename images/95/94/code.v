module top_module(
   input [3:0] in,
   output [3:0] out
);assign out = {in[1:0], 2'b00};

endmodule