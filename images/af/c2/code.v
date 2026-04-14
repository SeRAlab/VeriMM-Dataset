module register (
  input clk,
  input reset,
  input [2:0] in,
  output reg [2:0] out);always @(posedge clk) begin
    if (reset) out <= 3'b000;
    else out <= in;
end

endmodule