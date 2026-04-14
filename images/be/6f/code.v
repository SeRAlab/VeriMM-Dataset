module top_module(
   input clk,
   input reset,
   input [3:0] i_value,
   output reg [3:0] value
);always @(posedge clk or posedge reset) begin
      if (reset) begin
         value <= i_value;
      end else if (value == 4'hF) begin
         value <= 4'h0;
      end else begin
         value <= value + 4'h1;
      end
   end

endmodule