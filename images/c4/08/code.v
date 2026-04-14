module Test (
   input [31:0] in,
   output [31:0] out
);

   assign out = in ^ 32'h5a5a5a5a;

endmodule