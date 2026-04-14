module top_module(
   
   out,
   
   clk, in
   );typedef reg [2:0] three_t;

   input clk;
   input three_t in;
   output three_t out;

   always @(posedge clk) begin
      out <= ~in;
   end
endmodule