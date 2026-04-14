module top_module(
   input clk,
   input reset,
   input toggle,
   input in1,
   input in2,
   output reg out
);always @(posedge clk) begin
      if (reset) begin
         out <= 1'b0;
      end else if (toggle) begin
         out <= in1 ^ in2;
      end
   end

endmodule