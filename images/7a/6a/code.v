module fibonacci_lfsr(
  input clk,
  input rst_n,
  output reg [4:0] lfsr
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
      lfsr <= 5'b00001;
    else
      lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2]};
  end

endmodule