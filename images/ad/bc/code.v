module top_module(
  input clk, // Added clock input
  input [n-1:0] in,
  output reg out // Changed 'out' to be of type 'reg' since it is driven in an always block
);parameter n = 4; // number of input signals
  parameter seq = 4'b1010; // sequence to be detected
  
  // Define the states of the state machine
  parameter IDLE = 2'b00;
  parameter MATCH1 = 2'b01;
  parameter MATCH2 = 2'b10;
  
  // Define the current state and next state variables
  reg [1:0] state, next_state;
  
  // Define the sequence matching logic
  always @(*) begin
    case(state)
      IDLE: begin
        if(in == seq[0])
          next_state = MATCH1;
        else
          next_state = IDLE;
      end
      MATCH1: begin
        if(in == seq[1])
          next_state = MATCH2;
        else if(in == seq[0])
          next_state = MATCH1;
        else
          next_state = IDLE;
      end
      MATCH2: begin
        if(in == seq[2])
          next_state = IDLE;
        else if(in == seq[1])
          next_state = MATCH2;
        else if(in == seq[0])
          next_state = MATCH1;
        else
          next_state = IDLE;
      end
      default: next_state = IDLE; // Handle default case
    endcase
  end
  
  // Define the state transition logic
  always @(posedge clk) begin
    state <= next_state;
  end
  
  // Define the output logic
  always @(*) begin
    if(state == MATCH2)
      out = 1'b1;
    else
      out = 1'b0;
  end
  
endmodule