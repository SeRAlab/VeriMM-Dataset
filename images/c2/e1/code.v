module Concatenate(IN, OUT);

   input [3:0] IN;
   output [7:0] OUT;

   assign OUT = {IN, IN};

endmodule