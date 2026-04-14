module top_module(a, b, q, clk);parameter width = 16;

   input [width-1:0]  a, b; 
   input                     clk;
   output [width-1:0] q; 
   reg [width-1:0]    res; 

   assign                    q = res;


   always @(posedge clk) begin
     res <= a-b;
   end

endmodule