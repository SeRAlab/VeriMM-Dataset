module top_module(
  input in,
  output out
);parameter state0 = 2'b00; // initial state
parameter state1 = 2'b01; // intermediate state
parameter state2 = 2'b10; // final state

// define transitions between states
always @(in) begin
  case (state)
    state0: if (in == 1'b0) state <= state0; else state <= state1;
    state1: if (in == 1'b0) state <= state0; else state <= state2;
    state2: if (in == 1'b0) state <= state0; else state <= state2;
    default: state <= state0;
  endcase
end

// define output signal
assign out = (state == state2);

initial begin
  state <= state0;
end

// define current state
reg [1:0] state;

endmodule