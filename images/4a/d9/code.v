module top_module(
  input clk,
  input reset,
  input [99:0] in,
  output reg [99:0] out
);reg [99:0] temp;

always @(posedge clk) begin
  if (reset) begin
    temp <= 0;
    out <= 0;
  end else begin
    temp <= in;
    out <= temp;
  end
end

endmodule