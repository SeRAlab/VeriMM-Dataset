module top_module(
   input clk,
   input reset,
   input signed [15:0] a,
   input signed [15:0] b,
   output reg signed [16:0] sum,
   output reg signed [15:0] diff
   );always @(posedge clk) begin
      if (reset) begin
         sum <= 0;
         diff <= 0;
      end
      else begin
         sum <= a + b;
         if (a >= b) begin
            diff <= a - b;
         end
         else begin
            diff <= b - a;
         end
      end
   end

endmodule