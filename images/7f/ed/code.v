module top_module(
  input clk,
  input rst,
  output [n-1:0] out
);parameter n = 4; // number of states in the state machine

reg [n-1:0] state; // state register

always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= 1'b1; // Initialize to first state (one-hot encoding)
  end else begin
    state <= {state[n-2:0], state[n-1]}; // rotate states to maintain one-hot encoding
  end
end

assign out = state; // directly assign the state to out

endmodule