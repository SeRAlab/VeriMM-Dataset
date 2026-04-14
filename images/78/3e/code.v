module top_module( clk, rst, load, D, Q );input [0:0] D;
  output [0:0] Q;
  input clk, rst, load;
  wire n1, n2, n3, n4;

  // Inverter for reset signal
  assign n1 = ~rst;

  // AND gate to determine when to load data
  assign n2 = (n1 & load) | (load & ~D[0]);

  // Next state logic for the register based on clock and reset
  assign n4 = n3 ^ clk;   // XOR operation for deriving next state clocked signal

  // Register for holding the intermediate state `n3`
  reg [0:0] state; // Register declaration
  always @(posedge clk or negedge n1) begin
    if (!n1)
      state <= 0; // Active low reset
    else if (load)
      state <= D;
    else
      state <= state + 1; // Increment the register value
  end

  // Output register value
  assign Q[0] = state;

endmodule