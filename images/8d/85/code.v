module top_module(
  input BOOT,
  input S1,
  input S0,
  input clk,        // Added clk input
  output reg VALID
);// Define the four possible states
  parameter STATE_0 = 2'b00;
  parameter STATE_1 = 2'b01;
  parameter STATE_2 = 2'b10;
  parameter STATE_3 = 2'b11;

  // Define the state and next_state variables
  reg [1:0] state, next_state;

  // Define the state transition logic
  always @(*) begin
    case (state)
      STATE_0: begin
        if (BOOT) begin
          next_state = STATE_0;
        end else if (!S1 && S0) begin
          next_state = STATE_1;
        end else begin
          next_state = STATE_0;
        end
      end
      STATE_1: begin
        if (BOOT) begin
          next_state = STATE_0;
        end else if (S1 && !S0) begin
          next_state = STATE_2;
        end else begin
          next_state = STATE_1;
        end
      end
      STATE_2: begin
        if (BOOT) begin
          next_state = STATE_0;
        end else if (S1 && S0) begin
          next_state = STATE_3;
        end else begin
          next_state = STATE_2;
        end
      end
      STATE_3: begin
        if (BOOT) begin
          next_state = STATE_0;
        end else if (!S1 && !S0) begin
          next_state = STATE_0;
        end else begin
          next_state = STATE_3;
        end
      end
      default: next_state = STATE_0;  // Handle default case
    endcase
  end

  // Define the output logic
  always @(*) begin
    if (state == STATE_0 || state == STATE_1 || state == STATE_2 || state == STATE_3) begin
      VALID = 1'b1;
    end else begin
      VALID = 1'b0;
    end
  end

  // Update the state variable
  always @(posedge clk) begin
    if (BOOT) begin
      state <= STATE_0;
    end else begin
      state <= next_state;
    end
  end

endmodule