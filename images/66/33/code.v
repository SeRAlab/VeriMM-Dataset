module top_module(out, cout, a, b);input [7:0] a, b;
   output [7:0] out;
   output cout;
 
   assign #5 {cout, out} = a + b;
endmodule