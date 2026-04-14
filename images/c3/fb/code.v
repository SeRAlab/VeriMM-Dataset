module TwosComplement (
   input clk,
   input [3:0] in,
   output reg [3:0] out
   );

   always @(posedge clk) begin
      out <= ~in + 1;
   end

endmodule