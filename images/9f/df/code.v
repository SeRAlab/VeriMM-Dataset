module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input en, // enable signal
  output reg [n-1:0] out // output signals
);parameter n = 3; // number of output signals
parameter m = 8; // number of states (2^n)

reg [n-1:0] state; // current state
reg [n-1:0] next_state; // next state

// Gray code sequence
always @(*) begin
  case(state)
    0: next_state = 1;
    1: next_state = 3;
    2: next_state = 6;
    3: next_state = 4;
    4: next_state = 5;
    5: next_state = 7;
    6: next_state = 2;
    7: next_state = 0;
  endcase
end

// Output signals
always @(posedge clk) begin
  if (rst) begin
    state <= 0;
    out <= 0;
  end else if (en) begin
    state <= next_state;
    out <= state;
  end
end

endmodule