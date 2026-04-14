module fibonacci_lfsr(
  input clk,
  input rst_n,
  output reg [3:0] lfsr
);

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      lfsr <= 4'b0001;  // Initialize to a non-zero value
    end
    else begin
      lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
    end
  end

endmodule