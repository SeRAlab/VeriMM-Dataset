module lfsr_8bit(
  input clk,
  input rst_n,
  output reg [7:0] lfsr
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      lfsr <= 8'b00000001; // Initialize to a non-zero value
    else begin
      lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end
  end

endmodule