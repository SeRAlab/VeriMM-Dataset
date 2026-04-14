module top_module(
  input clk,
  input reset,
  input x3,
  input x2,
  input x1,
  output reg f
);// Define the two states
  parameter IDLE = 2'b00;
  parameter MATCH = 2'b01;

  // Define the input sequence to match
  parameter [2:0] MATCH_SEQ = 3'b101;

  // Define the state register and initialize to IDLE
  reg [1:0] state = IDLE;

  // Define the sequence register and initialize to 0
  reg [2:0] seq = 3'b0;

  // On rising edge of clock
  always @(posedge clk) begin
    // If reset is high, reset the state and sequence registers
    if (reset) begin
      state <= IDLE;
      seq <= 3'b0;
      f <= 1'b0;
    end
    else begin
      // Shift the input sequence into the sequence register
      seq <= {seq[1:0], x3};

      // State machine
      case (state)
        IDLE: begin
          // If the input sequence matches the match sequence, transition to MATCH state
          if (seq == MATCH_SEQ) begin
            state <= MATCH;
            f <= 1'b1;
          end
          else begin
            state <= IDLE;
            f <= 1'b0;
          end
        end
        MATCH: begin
          // If the input sequence no longer matches the match sequence, transition back to IDLE state
          if (seq != MATCH_SEQ) begin
            state <= IDLE;
            f <= 1'b0;
          end
          else begin
            state <= MATCH;
            f <= 1'b1;
          end
        end
      endcase
    end
  end

endmodule