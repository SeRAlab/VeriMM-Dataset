module top_module(
  input clk,
  input rst,
  output [n-1:0] out
);parameter n = 4; // number of states in the state machine

reg [n-1:0] state;
always @(posedge clk) begin
  if (rst) begin
    state <= {n{1'b0}}; // initial state
  end else begin
    state <= state + 1; // transition to next state
  end
end

assign out = {state}; // output signals indicate current state

endmodule