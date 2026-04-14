module top_module(
  input clk,
  output out1,
  output out2
);parameter n = 4; // number of bits in the counter

reg [n-1:0] state; // register to hold current state

// define sequence of states as a function of current state and clock signal
always @(posedge clk) begin
  state <= {state[n-2:0], ~state[n-1]};
end

// connect current state to output signals
assign out1 = state[0];
assign out2 = ~state[0];

endmodule