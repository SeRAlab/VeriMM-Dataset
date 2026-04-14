module top_module(
  input [n-1:0] in,
  output reg [m-1:0] out, // Changed 'out' to 'reg' type
  input clk,
  input rst
);// Define the parameters for input and output widths
  parameter n = 1; // Set a default value for n
  parameter m = 2; // Set a default value for m

  // Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define the inputs
  parameter I0 = 1'b0;
  parameter I1 = 1'b1;

  // Define the outputs
  parameter O0 = 1'b0;
  parameter O1 = 1'b1;

  // Define the state register and next state logic
  reg [1:0] state, next_state;

  // State transition logic
  always @(posedge clk or negedge rst) begin
    if (~rst) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end
  
  // Output logic based on current state
  always @(state) begin
    case (state)
      S0: out = {O0, O0};
      S1: out = {O0, O1};
      S2: out = {O1, O0};
      S3: out = {O1, O1};
    endcase
  end

  // Next state logic
  always @(state or in) begin
    case (state)
      S0: next_state = (in == I0) ? S1 : S2;
      S1: next_state = (in == I0) ? S0 : S3;
      S2: next_state = (in == I0) ? S3 : S0;
      S3: next_state = (in == I0) ? S2 : S1;
      default: next_state = S0; // Add a default case for safety
    endcase
  end

endmodule