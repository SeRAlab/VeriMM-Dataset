module top_module(
   input clk,
   input rst,
   input [3:0] in_val,
   output reg [3:0] out_val
);always @(posedge clk) begin
      if (rst) begin
         out_val <= 4'b0000;
      end else begin
         out_val <= in_val + 2;
      end
   end

endmodule