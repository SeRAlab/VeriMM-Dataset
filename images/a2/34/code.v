module top_module(
   
   y,
   
   a
   );input signed [7:0] a;
   output [15:0]      y;
   
   assign y = ~66'd0 <<< {4{a}};
   
endmodule