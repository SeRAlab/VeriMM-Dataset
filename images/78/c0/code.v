module top_module(
  input clk,
  input reset,
  input [n-1:0] seed,
  output reg [n-1:0] rand_num
);parameter n = 8; // number of bits in the randomly generated number

reg [n-1:0] lfsr; // linear feedback shift register

always @(posedge clk) begin
  if (reset) begin
    lfsr <= seed; // reset LFSR to seed value
  end else begin
    lfsr <= {lfsr[n-2:0], lfsr[0] ^ lfsr[n-1]}; // LFSR update
  end
end

always @(posedge clk) begin
  if (!reset) begin
    rand_num <= lfsr; // output randomly generated binary number
  end
end

endmodule