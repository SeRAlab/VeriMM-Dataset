module top_module(
  input clk,
  input reset,
  output reg [n-1:0] state,
  output reg [n-1:0] next_state
);parameter n = 4; // number of states

reg [n-1:0] state_reg;
always @(posedge clk, posedge reset)
begin
  if (reset)
    state_reg <= {n{1'b0}};
  else
    state_reg <= next_state;
end

always @*
begin
  case(state_reg)
    4'b0001: next_state = 4'b0010; // state 1
    4'b0010: next_state = 4'b0100; // state 2
    4'b0100: next_state = 4'b1000; // state 3
    4'b1000: next_state = 4'b0001; // state 4
    default: next_state = 4'b0001; // default state
  endcase
end

assign state = state_reg;

endmodule