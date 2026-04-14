module top_module(
   input wire clk,
   output reg o
);always @(posedge clk) begin
      if (1'bx) o <= 1'd1; else o <= 1'd0;
   end
endmodule