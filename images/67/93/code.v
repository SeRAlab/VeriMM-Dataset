module top_module(
  input clk,
  input rst,
  output [n-1:0] out
);parameter n = 4; // number of states in the state machine

reg [n-1:0] state; // register to hold the current state

always @(posedge clk) begin
  if (rst) begin
    state <= 0; // reset the state to 0
  end else begin
    // set the next state based on the current state
    case (state)
      0: state <= 1;
      1: state <= 2;
      2: state <= 3;
      3: state <= 0;
      default: state <= 0;
    endcase
  end
end

// assign the output signals based on the current state
assign out = {state == 0, state == 1, state == 2, state == 3};

endmodule