module top_module(
  input clk,
  input reset,
  output reg [7:0] count
);reg [7:0] sr [0:7];
  wire xor_out;

  assign xor_out = sr[0][7] ^ sr[1][7] ^ sr[2][7] ^ sr[3][7] ^ sr[4][7] ^ sr[5][7] ^ sr[6][7] ^ sr[7][7] ^ sr[0][15] ^ sr[1][15] ^ sr[2][15] ^ sr[3][15] ^ sr[4][15] ^ sr[5][15] ^ sr[6][15] ^ sr[7][15];

  always @(posedge clk) begin
    if (reset) begin
      count <= 8'b00000000;
      sr[0] <= 8'b00000000;
      sr[1] <= 8'b00000000;
      sr[2] <= 8'b00000000;
      sr[3] <= 8'b00000000;
      sr[4] <= 8'b00000000;
      sr[5] <= 8'b00000000;
      sr[6] <= 8'b00000000;
      sr[7] <= 8'b00000000;
    end else begin
      sr[0] <= {sr[0][6:0], xor_out};
      sr[1] <= {sr[1][6:0], sr[0][7]};
      sr[2] <= {sr[2][6:0], sr[1][7]};
      sr[3] <= {sr[3][6:0], sr[2][7]};
      sr[4] <= {sr[4][6:0], sr[3][7]};
      sr[5] <= {sr[5][6:0], sr[4][7]};
      sr[6] <= {sr[6][6:0], sr[5][7]};
      sr[7] <= {sr[7][6:0], sr[6][7]};
      count <= {sr[7][3:0], sr[3][3:0]};
    end
  end

endmodule