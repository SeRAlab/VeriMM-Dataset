module top_module(
  input clk,
  input reset,
  input data,
  output reg [3:0] cnt
);// Define the states of the FSM
  parameter IDLE = 2'b00;
  parameter COUNT = 2'b01;
  parameter DONE = 2'b10;

  // Define the current state and next state variables
  reg [1:0] state, next_state;

  // Define the output register for cnt
  reg [3:0] cnt_reg;

  // Define the combinational logic for the next state and cnt
  always @ (posedge clk or negedge reset) begin
    if (reset == 0) begin
      state <= IDLE;
      cnt_reg <= 0;
    end else begin
      state <= next_state;
      cnt_reg <= cnt_reg;
    end
  end

  always @ (*) begin
    case (state)
      IDLE: begin
        next_state = COUNT;
        cnt = 0;
      end
      COUNT: begin
        if (data == 1) begin
          next_state = COUNT;
          cnt = cnt_reg + 1;
        end else begin
          next_state = DONE;
          cnt = cnt_reg;
        end
      end
      DONE: begin
        next_state = IDLE;
        cnt = cnt_reg;
      end
    endcase
  end

endmodule