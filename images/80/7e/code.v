module top_module(
  input clk,
  input reset,
  input in1,
  input in2,
  input in3,
  input in4,
  output reg match
);// Define states
parameter S0 = 2'b01;
parameter S1 = 2'b10;

// Define current state and next state
reg [1:0] state, next_state;

// Define output logic
always @ (state)
begin
  case (state)
    S0: match = 1'b0;
    S1: match = 1'b1;
    default: match = 1'b0;
  endcase
end

// Define next state logic
always @ (in1, in2, in3, in4, state)
begin
  next_state = state;
  case (state)
    S0:
      if (in1 == 1'b1)
        next_state = S1;
    S1:
      if ((in1 == 1'b0) || (in2 == 1'b0) || (in3 == 1'b1) || (in4 == 1'b0))
        next_state = S0;
    default:
      next_state = S0;
  endcase
end

// Define state transition
always @ (posedge clk, posedge reset)
begin
  if (reset)
    state <= S0;
  else
    state <= next_state;
end

endmodule