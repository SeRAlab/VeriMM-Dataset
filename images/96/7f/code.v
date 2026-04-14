module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] state; // state variable to keep track of current state

always @(posedge clk) begin
  state <= {state[n-2:0], state[n-1]}; // shift the state to the left
  out <= {1'b0, state[n-1]}; // set the current state output to high
end

endmodule