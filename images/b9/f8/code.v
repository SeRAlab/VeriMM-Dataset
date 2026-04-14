module top_module(input clk, input wire signed [31:0] in, output reg signed [31:0] out);always @(posedge clk) begin
      out <= in + 1;
   end
endmodule