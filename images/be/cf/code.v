module top_module(
  input clk,
  input rst,
  input in,
  output reg out  // Change from wire to reg to hold the output state
);// Define the states
  parameter State1 = 2'b00;
  parameter State2 = 2'b01;
  parameter State3 = 2'b10;

  // Define the state register and next state logic
  reg [1:0] state, next_state;

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      state <= State1;
    end else begin
      state <= next_state;
    end
  end

  // Define the output function
  always @(state, in) begin
    case(state)
      State1: out = 1'b0;
      State2: out = 1'b1;
      State3: out = 1'b1;
      default: out = 1'b0; // Add a default case for safety
    endcase
  end

  // Define the next state logic
  always @(state, in) begin
    case(state)
      State1: if (in) begin
                next_state = State2;
              end else begin
                next_state = State1;
              end
      State2: if (!in) begin
                next_state = State3;
              end else begin
                next_state = State2;
              end
      State3: if (in) begin
                next_state = State1;
              end else begin
                next_state = State3;
              end
      default: next_state = State1; // Add a default case for safety
    endcase
  end

endmodule