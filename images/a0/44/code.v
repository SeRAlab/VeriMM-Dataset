module top_module(
  input clk,
  input reset,
  input [15:0] scancode,
  output reg match
);// Define the states
  parameter IDLE = 2'b00;
  parameter LEFT = 2'b01;
  parameter UP = 2'b10;
  parameter RIGHT = 2'b11;
  
  // Define the transitions
  always @(posedge clk) begin
    if (reset) begin
      match <= 0;
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (scancode == 4'b0001) begin // Left
            state <= LEFT;
          end
        end
        LEFT: begin
          if (scancode == 4'b0010) begin // Up
            state <= UP;
          end else begin
            state <= IDLE;
          end
        end
        UP: begin
          if (scancode == 4'b0100) begin // Right
            state <= RIGHT;
          end else begin
            state <= IDLE;
          end
        end
        RIGHT: begin
          if (scancode == 4'b1000) begin // Down
            match <= 1;
            state <= IDLE;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end
  
  // Define the initial state
  reg [1:0] state = IDLE;
  
endmodule