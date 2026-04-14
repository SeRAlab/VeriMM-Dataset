module top_module(
  input clk,
  input reset,
  input i,
  input j,
  input k,
  output reg out1,
  output reg out2
);// Define state types
  parameter IDLE = 2'b00;
  parameter STATE1 = 2'b01;
  parameter STATE2 = 2'b10;

  // Define state register and output registers
  reg [1:0] state, next_state;
  reg next_out1, next_out2;

  // Synchronous reset to IDLE
  always @(posedge clk) begin
    if (reset) begin
      state <= IDLE;
      out1 <= 0;
      out2 <= 0;
    end
    else begin
      state <= next_state;
      out1 <= next_out1;
      out2 <= next_out2;
    end
  end

  // Define next state and output logic
  always @(*) begin
    case (state)
      IDLE: begin
        if (i) begin
          next_state = STATE1;
          next_out1 = 0;
          next_out2 = 0;
        end
        else begin
          next_state = IDLE;
          next_out1 = 0;
          next_out2 = 0;
        end
      end
      STATE1: begin
        if (j) begin
          next_state = STATE2;
          next_out1 = 1;
          next_out2 = 0;
        end
        else begin
          next_state = STATE1;
          next_out1 = 1;
          next_out2 = 0;
        end
      end
      STATE2: begin
        if (k) begin
          next_state = IDLE;
          next_out1 = 0;
          next_out2 = 1;
        end
        else begin
          next_state = STATE2;
          next_out1 = 0;
          next_out2 = 1;
        end
      end
    endcase
  end

endmodule