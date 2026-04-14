module top_module(
  input clk,
  input reset,
  input x,
  input y,
  output reg z
);// Define the state variable and its possible values
  reg [1:0] state, next_state;
  parameter IDLE = 2'b00, WAIT = 2'b01, OUTPUT = 2'b10;
  
  // Define the state transition logic
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
  // Define the next state logic
  always @ (*) begin
    case (state)
      IDLE: begin
        if (x) begin
          next_state = WAIT;
          z = 0;
        end else begin
          next_state = IDLE;
          z = 0;
        end
      end
      WAIT: begin
        if (y) begin
          next_state = OUTPUT;
          z = 1;
        end else begin
          next_state = WAIT;
          z = 0;
        end
      end
      OUTPUT: begin
        if (!x || y) begin
          next_state = IDLE;
          z = 0;
        end else begin
          next_state = OUTPUT;
          z = 1;
        end
      end
    endcase
  end
  
endmodule