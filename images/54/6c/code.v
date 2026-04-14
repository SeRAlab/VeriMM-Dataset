module top_module(
  input clk,
  input reset,
  input [3:0] binary_in,
  output [3:0] gray_out
);reg [3:0] binary_reg;
  assign gray_out = binary_reg ^ (binary_reg >> 1);

  always @(posedge clk) begin
    if (reset) begin
      binary_reg <= 4'b0000;
    end else if (binary_in != binary_reg) begin
      binary_reg <= binary_in;
    end
  end

endmodule