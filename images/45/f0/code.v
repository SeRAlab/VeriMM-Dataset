module top_module(
  input clk,                // Added the clock input
  input [m-1:0] in,
  output reg [n-1:0] out   // Changed 'out' to reg
);parameter n = 4; // number of states
parameter m = 2; // number of inputs

reg [n-1:0] state; // current state
reg [n-1:0] next_state; // next state

// Define your state transition and output logic here
always @ (state or in) begin // Include 'state' for sensitivity list
  case (state)
    0: if (in[0] && in[1]) next_state = 3; 
       else if (in[0]) next_state = 1; 
       else if (in[1]) next_state = 2; 
       else next_state = 0;
    1: if (in[0] && in[1]) next_state = 3; 
       else if (in[1]) next_state = 2; 
       else next_state = 0;
    2: if (in[0] && in[1]) next_state = 3; 
       else if (in[0]) next_state = 1; 
       else next_state = 0;
    3: if (in[0] && in[1]) next_state = 3; 
       else if (in[0]) next_state = 1; 
       else if (in[1]) next_state = 2; 
       else next_state = 0;
  endcase
end

always @ (state) begin  // Only need 'state' here for output logic
  case (state)
    0: out = {1'b0, 1'b0, 1'b0, 1'b1};
    1: out = {1'b0, 1'b0, 1'b1, 1'b0};
    2: out = {1'b0, 1'b1, 1'b0, 1'b0};
    3: out = {1'b1, 1'b0, 1'b0, 1'b0};
    default: out = {n{1'b0}}; // Handle default case
  endcase
end

always @ (posedge clk) begin
  state <= next_state;
end

endmodule