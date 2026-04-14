module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);// Define states
  parameter START = 2'b00;
  parameter STATE1 = 2'b01;
  parameter MATCH = 2'b10;

  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      state <= START;
    end else begin
      state <= next_state;
    end
  end

  // Define match output logic
  always @(state) begin
    if (state == MATCH) begin
      match <= 1;
    end else begin
      match <= 0;
    end
  end

  // Define next state logic
  always @(state, data) begin
    case (state)
      START: begin
        if (data == 1) begin
          next_state = STATE1;
        end else begin
          next_state = START;
        end
      end
      STATE1: begin
        if (data == 0) begin
          next_state = MATCH;
        end else begin
          next_state = START;
        end
      end
      MATCH: begin
        if (data == 1) begin
          next_state = START;
        end else begin
          next_state = MATCH;
        end
      end
      default: begin
        next_state = START;
      end
    endcase
  end

endmodule