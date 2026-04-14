module top_module(
  input clk,
  input rst,
  output reg [2:0] count
);// Define the states
  parameter IDLE = 2'b00;
  parameter COUNTING = 2'b01;
  parameter RESET = 2'b10;

  // Define the current state and next state variables
  reg [1:0] current_state, next_state;

  // Define the counter variable
  reg [2:0] counter;

  // Assign the initial state to idle and the counter to 0
  initial begin
    current_state = IDLE;
    counter = 3'b000;
  end

  // Define the state machine
  always @ (posedge clk) begin
    // Set the next state based on the current state and inputs
    case (current_state)
      IDLE: begin
        if (rst) begin
          next_state = RESET;
        end else begin
          next_state = COUNTING;
        end
      end
      COUNTING: begin
        if (counter == 3'b111) begin
          next_state = IDLE;
        end else begin
          next_state = COUNTING;
        end
      end
      RESET: begin
        next_state = IDLE;
      end
    endcase

    // Set the current state to the next state
    current_state <= next_state;

    // Update the counter based on the current state
    case (current_state)
      COUNTING: begin
        counter <= counter + 1;
      end
      RESET: begin
        counter <= 3'b000;
      end
    endcase
  end

  // Assign the counter to the output
  assign count = counter;

endmodule