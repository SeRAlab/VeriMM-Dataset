module top_module(
  input clk,      // Add clock input
  input in,
  output reg out  // Change out to reg type
);// Define the states of the state machine
  parameter STATE0 = 2'b00;
  parameter STATE1 = 2'b01;
  parameter STATE2 = 2'b10;
  
  // Define the current state and next state variables
  reg [1:0] current_state;
  reg [1:0] next_state;
  
  // Initialize the current state to STATE0
  initial begin
    current_state = STATE0;
    out = 0; // Initialize out
  end
  
  // Define the state transition logic
  always @ (current_state or in) begin
    case (current_state)
      STATE0: begin
        if (in == 1) begin
          next_state = STATE1;
          out = 0; // Reset output
        end else begin
          next_state = STATE0;
          out = 0; // Reset output
        end
      end
      STATE1: begin
        if (in == 0) begin
          next_state = STATE0;
          out = 0; // Reset output
        end else begin
          next_state = STATE2;
          out = 0; // Reset output
        end
      end
      STATE2: begin
        if (in == 1) begin
          next_state = STATE0;
          out = 1; // Set output to indicate detection
        end else begin
          next_state = STATE0;
          out = 0; // Reset output
        end
      end
      default: begin
        next_state = STATE0; // Default to STATE0
        out = 0; // Reset output
      end
    endcase
  end
  
  // Update the current state with the next state on clock edge
  always @ (posedge clk) begin
    current_state <= next_state;
  end
  
endmodule