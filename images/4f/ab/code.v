module top_module(
  input clk,
  input reset,
  input coin,
  output reg [1:0] display,
  output reg product_select,
  output reg dispense
);// Define the three states
  parameter IDLE = 2'b00;
  parameter SELECTING = 2'b01;
  parameter DISPENSING = 2'b10;

  // Define the state register and initialize to IDLE
  reg [1:0] state_reg = IDLE;

  // Define the next state logic
  always @ (posedge clk, negedge reset) begin
    if (reset == 0) begin
      state_reg <= IDLE;
    end else begin
      case (state_reg)
        IDLE: begin
          if (coin == 1) begin
            state_reg <= SELECTING;
          end
        end
        SELECTING: begin
          if (coin == 0) begin
            state_reg <= DISPENSING;
          end
        end
        DISPENSING: begin
          state_reg <= IDLE;
        end
      endcase
    end
  end

  // Define the output logic
  always @ (state_reg) begin
    case (state_reg)
      IDLE: begin
        display <= 2'b00;
        product_select <= 0;
        dispense <= 0;
      end
      SELECTING: begin
        display <= 2'b01;
        product_select <= 1;
        dispense <= 0;
      end
      DISPENSING: begin
        display <= 2'b10;
        product_select <= 0;
        dispense <= 1;
      end
    endcase
  end

endmodule