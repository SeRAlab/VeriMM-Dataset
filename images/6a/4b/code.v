module top_module(
  input clk, // clock signal
  input rst, // reset signal
  output reg [n-1:0] out // output signals
);parameter k = 4; // number of states
parameter n = 2; // number of output signals

// define the states using a parameter
parameter [k-1:0] STATE_A = 2'b00;
parameter [k-1:0] STATE_B = 2'b01;
parameter [k-1:0] STATE_C = 2'b10;
parameter [k-1:0] STATE_D = 2'b11;

// define the output signals for each state
parameter [n-1:0] OUT_A = 2'b00;
parameter [n-1:0] OUT_B = 2'b01;
parameter [n-1:0] OUT_C = 2'b10;
parameter [n-1:0] OUT_D = 2'b11;

// define the state register and the next state logic
reg [k-1:0] state_reg, next_state;

always @ (posedge clk or posedge rst) begin
  if (rst) begin
    state_reg <= STATE_A;
  end else begin
    state_reg <= next_state;
  end
end

// define the output logic
always @ (state_reg) begin
  case (state_reg)
    STATE_A: out = OUT_A;
    STATE_B: out = OUT_B;
    STATE_C: out = OUT_C;
    STATE_D: out = OUT_D;
    default: out = OUT_A; // default case to avoid latches
  endcase
end

// define the next state logic
always @ (state_reg) begin
  case (state_reg)
    STATE_A: next_state = STATE_B;
    STATE_B: next_state = STATE_C;
    STATE_C: next_state = STATE_D;
    STATE_D: next_state = STATE_A;
    default: next_state = STATE_A; // default case to avoid latches
  endcase
end

endmodule