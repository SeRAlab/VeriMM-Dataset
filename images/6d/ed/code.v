module top_module(
             res,
             
             clk,
             in
   );output reg [1:0] res;
   input         clk;
   input         in;

   
   generate
      genvar i;
      for (i=0; i<2; i=i+1) begin
         always @(posedge clk) begin
            res[i:i] <= in;
         end
      end
   endgenerate
endmodule