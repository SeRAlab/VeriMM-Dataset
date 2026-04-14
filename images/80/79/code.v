module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);// Define the states of the FSM
  parameter IDLE = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  // Define the state register and initialize to IDLE state
  reg [1:0] state = IDLE;
  
  // Define the next state logic
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= IDLE;
    end else begin
      case (state)
        IDLE: begin
          if (data == 1'b1) begin
            state <= S1;
          end else begin
            state <= IDLE;
          end
        end
        S1: begin
          if (data == 1'b0) begin
            state <= S2;
          end else begin
            state <= IDLE;
          end
        end
        S2: begin
          if (data == 1'b1) begin
            state <= S3;
          end else begin
            state <= IDLE;
          end
        end
        S3: begin
          if (data == 1'b0) begin
            state <= IDLE;
            match <= 1'b1;
          end else begin
            state <= IDLE;
          end
        end
      endcase
    end
  end
endmodule