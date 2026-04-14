module top_module(
  input clk,
  input rst,
  output reg [n-1:0] rnum
);parameter n = 8; // number of bits in the random number

reg [n-1:0] lfsr; // linear feedback shift register

always @(posedge clk) begin
  if (rst) begin
    lfsr <= {n{1'b1}}; // initialize LFSR to all ones
  end else begin
    lfsr <= {lfsr[n-2:0], lfsr[0] ^ lfsr[n-1]}; // shift and XOR
  end
  rnum <= lfsr; // output random number
end

endmodule