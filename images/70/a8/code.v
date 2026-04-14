module top_module(
  input clk,
  output reg green_ns,
  output reg yellow_ns,
  output reg green_ew,
  output reg yellow_ew
);// Define the states
  parameter STATE_1 = 2'b00;
  parameter STATE_2 = 2'b01;
  parameter STATE_3 = 2'b10;
  parameter STATE_4 = 2'b11;
  
  // Define the state register and initialize to state 1
  reg [1:0] state_reg = STATE_1;
  
  // Define the state transition logic
  always @(posedge clk) begin
    case(state_reg)
      STATE_1: begin
        green_ns <= 1;
        yellow_ns <= 0;
        green_ew <= 0;
        yellow_ew <= 0;
        if (count == 10) begin
          state_reg <= STATE_2;
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end
      
      STATE_2: begin
        green_ns <= 0;
        yellow_ns <= 1;
        green_ew <= 0;
        yellow_ew <= 0;
        if (count == 2) begin
          state_reg <= STATE_3;
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end
      
      STATE_3: begin
        green_ns <= 0;
        yellow_ns <= 0;
        green_ew <= 1;
        yellow_ew <= 0;
        if (count == 10) begin
          state_reg <= STATE_4;
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end
      
      STATE_4: begin
        green_ns <= 0;
        yellow_ns <= 0;
        green_ew <= 0;
        yellow_ew <= 1;
        if (count == 2) begin
          state_reg <= STATE_1;
          count <= 0;
        end else begin
          count <= count + 1;
        end
      end
    endcase
  end
  
  // Define the count register for the state transitions
  reg [3:0] count = 0;
  
endmodule