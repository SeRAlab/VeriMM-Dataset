module johnson_counter (
  input clk,
  output [n-1:0] out
);

  parameter n = 4; // number of output signals

  reg [n-1:0] state;
  wire [n-1:0] next_state;

  assign out = state;

  always @ (posedge clk) begin
    state <= next_state;
  end

  assign next_state[0] = state[n-1] ^ state[0];
  assign next_state[1] = state[0] ^ state[1];
  assign next_state[2] = state[1] ^ state[2];
  assign next_state[3] = state[2] ^ state[3];

endmodule