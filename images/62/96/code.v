module top_module(
  input clk,
  input reset,
  input [3:0] data_in,
  output reg match
);// Define states
  parameter IDLE = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  
  // Define state register and next state logic
  reg [1:0] state, next_state;
  always @ (posedge clk, posedge reset) begin
    if (reset) begin
      state <= IDLE;
    end else begin
      state <= next_state;
    end
  end
  
  // Define output logic
  always @ (state, data_in) begin
    match = 0;
    case (state)
      IDLE: begin
        if (data_in == 4'b1_0_1_0) begin
          next_state = S1;
        end else begin
          next_state = IDLE;
        end
      end
      S1: begin
        if (data_in == 4'b1_0_1_0) begin
          next_state = S2;
        end else begin
          next_state = IDLE;
        end
      end
      S2: begin
        if (data_in == 4'b1_0_1_0) begin
          next_state = S1;
          match = 1;
        end else begin
          next_state = IDLE;
        end
      end
      default: next_state = IDLE;
    endcase
  end
  
endmodule