module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg d1, d2;
  wire xor_out;

  // Continuous assignment for xor_out
  assign xor_out = d1 ^ d2;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      d1 <= 1'b0;
      d2 <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      d1 <= a;
      d2 <= d1;
      rise <= xor_out & ~d1;
      down <= xor_out & d1;
    end
  end

endmodule