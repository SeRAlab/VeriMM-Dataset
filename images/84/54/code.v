module top_module(
  input               clk,
  input               rst_n,
  input               a,
  output reg          rise,
  output reg          down
);reg [1:0]           a_reg [2:0];
  reg [1:0]           diff_reg [1:0];

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a_reg[0] <= 2'b0;
      a_reg[1] <= 2'b0;
      a_reg[2] <= 2'b0;
      diff_reg[0] <= 2'b0;
      diff_reg[1] <= 2'b0;
      rise <= 1'b0;
      down <= 1'b0;
    end else begin
      a_reg[0] <= a;
      a_reg[1] <= a_reg[0];
      a_reg[2] <= a_reg[1];

      diff_reg[0] <= a_reg[2] ^ a_reg[1]; // Correct indexing for calculation
      diff_reg[1] <= a_reg[1] ^ a_reg[0];

      rise <= diff_reg[1][1] & ~diff_reg[1][0];
      down <= diff_reg[0][1] & ~diff_reg[0][0];
    end
  end

endmodule