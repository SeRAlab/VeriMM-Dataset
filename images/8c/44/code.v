module top_module(
  input in,
  output reg out // changed output to reg to allow assignment in always block
);parameter n = 4; // length of sequence to be detected
parameter seq = 4'b0110; // sequence to be detected

reg [1:0] state; // changed to 2 bits to track the current state correctly

always @(posedge in) begin
  if (state == n-1 && in == seq[state]) begin
    out <= 1; // sequence detected
    state <= 0; // reset state
  end else if (in == seq[state]) begin
    state <= state + 1; // advance to next state
  end else begin
    state <= 0; // reset state
    out <= 0; // sequence not detected
  end
end

endmodule