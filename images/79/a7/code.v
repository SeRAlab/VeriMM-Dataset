module top_module(clk, d, q);parameter WIDTH = 32;
   input clk;
   input [WIDTH-1:0] d;
   output [WIDTH-1:0] q;

   reg [WIDTH-1:0]    qr;

   

   always @(clk or d)
     if (clk == 1'b0)
       qr <= d;

   

   assign q = qr;
endmodule