module register (
  input clk,
  input reset,
  input [7:0] in,
  output reg [7:0] out);always @(posedge clk) begin
    if (reset) out <= 8'b00000000;
    else out <= in;
end

endmodule