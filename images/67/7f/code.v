module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg a_d1;
  reg a_d2;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a_d1 <= 1'b0;
      a_d2 <= 1'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end
    else begin
      a_d2 <= a_d1;
      a_d1 <= a;
      rise <= (a_d1 ^ a_d2) & a_d1;
      down <= (a_d1 ^ a_d2) & ~a_d1;
    end
  end

endmodule