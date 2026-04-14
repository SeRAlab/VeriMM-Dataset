module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input [31:0] seed, // seed value
  output reg [m-1:0] out // sequence of pseudorandom numbers
);parameter m = 8; // number of pseudorandom numbers to generate

reg [31:0] state; // internal state of the PRNG

always @(posedge clk) begin
  if (rst) begin
    state <= seed; // initialize the state with the seed value
    out <= 0; // reset the output to 0
  end else begin
    state <= state ^ (state << 13);
    state <= state ^ (state >> 17);
    state <= state ^ (state << 5); // PRNG algorithm
    out <= {out[m-2:0], state[0]}; // output the least significant bit of the state
  end
end

endmodule