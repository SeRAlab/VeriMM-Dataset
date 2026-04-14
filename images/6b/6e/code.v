module top_module(
  input clk,
  input reset,
  input [7:0] data,
  output reg [3:0] count
);// Declare state variables
  reg [1:0] state, next_state;

  // Declare count variable
  reg [3:0] count_reg;

  // Assign initial state
  initial state = 2'b00;

  // Assign default values
  always @(*) begin
    next_state = state;
    count = count_reg;
  end

  // FSM logic
  always @(posedge clk) begin
    // State transition logic
    case(state)
      2'b00: begin // Reset state
        if(reset) begin
          next_state = 2'b00;
          count_reg = 4'b0000;
        end
        else if(data == 8'b11111111) begin
          next_state = 2'b01;
          count_reg = 4'b0001;
        end
      end
      2'b01: begin // Counting state
        if(data == 8'b11111111) begin
          next_state = 2'b01;
          count_reg = count_reg + 1;
        end
        else begin
          next_state = 2'b00;
          count_reg = 4'b0000;
        end
      end
    endcase

    // Update state and count
    state <= next_state;
    count <= count_reg;
  end

endmodule