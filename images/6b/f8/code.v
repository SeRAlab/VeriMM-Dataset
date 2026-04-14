module top_module(
  input clk,
  output [n-1:0] out
);parameter n = 4; // number of output signals

reg [n-1:0] state; // register to hold current state
wire [n-1:0] next_state; // wire to hold next state

// define the flip-flops and their connections
always @(posedge clk) begin
  state <= next_state;
end

// define the logic that generates the sequence of binary numbers
assign next_state = {state[n-2:0], ~state[n-1] ^ state[n-2]};

// use the output signals to indicate the current state of the Johnson counter
assign out = state;

endmodule