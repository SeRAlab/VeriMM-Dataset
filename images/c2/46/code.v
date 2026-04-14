module binary_counter (
  clk,
  reset,
  enable,
  out
);

input wire clk;
input wire reset;
input wire enable;
output reg [3:0] out;

always @(posedge clk) begin
  if (reset) begin
    out <= 4'b0000;
  end else if (enable) begin
    out <= out + 1;
  end
end

endmodule