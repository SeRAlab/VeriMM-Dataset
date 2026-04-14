module top_module(
  input clk,
  input reset,
  output reg red,
  output reg yellow,
  output reg green
);// Define states
  parameter STATE_RED = 2'b00;
  parameter STATE_GREEN = 2'b01;
  parameter STATE_YELLOW = 2'b10;

  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clk, negedge reset) begin
    if (!reset) begin
      state <= STATE_RED;
    end else begin
      state <= next_state;
    end
  end

  // Define state transition logic
  always @ (state) begin
    case (state)
      STATE_RED: begin
        next_state = STATE_GREEN;
      end
      STATE_GREEN: begin
        next_state = STATE_YELLOW;
      end
      STATE_YELLOW: begin
        next_state = STATE_RED;
      end
      default: begin
        next_state = STATE_RED;
      end
    endcase
  end

  // Define output logic
  always @ (state) begin
    case (state)
      STATE_RED: begin
        red = 1'b1;
        yellow = 1'b0;
        green = 1'b0;
      end
      STATE_GREEN: begin
        red = 1'b0;
        yellow = 1'b0;
        green = 1'b1;
      end
      STATE_YELLOW: begin
        red = 1'b0;
        yellow = 1'b1;
        green = 1'b0;
      end
      default: begin
        red = 1'b1;
        yellow = 1'b0;
        green = 1'b0;
      end
    endcase
  end

endmodule