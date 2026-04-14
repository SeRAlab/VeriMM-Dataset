module top_module(
  input clk,
  output reg [n-1:0] out
);parameter n = 4; // number of states

// define the sequence of states
reg [n-1:0] states;
wire [n-1:0] next_states;

assign next_states = {states[n-2:0], states[n-1]};

always @(posedge clk) begin
  states <= next_states;
end

assign out = states;

endmodule