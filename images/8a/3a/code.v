module top_module(
   input [3:0] w3 ,
   input [3:0] w2 ,
   input [3:0] w1 ,
   input [3:0] w0 ,
   input [1:0] sel ,
   output [3:0] y
);assign y=sel[1]?(sel[0]?w3:w2):(sel[0]?w1:w0);
  endmodule