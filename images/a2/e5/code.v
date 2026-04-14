module top_module(
  input [n-1:0] state,
  input clk,
  output reg [n-1:0] next_state  // Changed to reg because it will be driven in always block
);parameter n = 3; // number of bits in the state

// Define the Gray code states
reg [n-1:0] gray_states [0:2**n-1];
integer i;
initial begin
  for (i = 0; i < 2**n; i = i + 1) begin
    gray_states[i] = i ^ (i >> 1);
  end
end

// Define the Gray code state transition table
reg [n-1:0] gray_transition_table [0:2**n-1][0:1];
initial begin
  gray_transition_table[0][0] = 'h1;
  gray_transition_table[0][1] = 'h2;
  gray_transition_table[1][0] = 'h3;
  gray_transition_table[1][1] = 'h0;
  gray_transition_table[2][0] = 'h6;
  gray_transition_table[2][1] = 'h7;
  gray_transition_table[3][0] = 'h5;
  gray_transition_table[3][1] = 'h4;
  gray_transition_table[4][0] = 'h4;
  gray_transition_table[4][1] = 'h5;
  gray_transition_table[5][0] = 'h7;
  gray_transition_table[5][1] = 'h6;
  gray_transition_table[6][0] = 'h2;
  gray_transition_table[6][1] = 'h1;
  gray_transition_table[7][0] = 'h0;
  gray_transition_table[7][1] = 'h3;
end

// Compute the next state based on the current state and the clock signal
always @(posedge clk) begin
  next_state <= gray_transition_table[state][1];
end

endmodule