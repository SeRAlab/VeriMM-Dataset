module top_module(
  input clk,
  input reset,
  input input_data,
  output reg match
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  // Define the current state
  reg [1:0] current_state;
  
  // Define the next state
  reg [1:0] next_state;
  
  // Define the state machine
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= S0;
      match <= 1'b0;
    end else begin
      current_state <= next_state;
      match <= 1'b0;
      case (current_state)
        S0: begin
          if (input_data == 1'b1) begin
            next_state <= S1;
          end else begin
            next_state <= S0;
          end
        end
        S1: begin
          if (input_data == 1'b1) begin
            next_state <= S2;
          end else begin
            next_state <= S0;
          end
        end
        S2: begin
          if (input_data == 1'b0) begin
            next_state <= S3;
          end else begin
            next_state <= S0;
          end
        end
        S3: begin
          if (input_data == 1'b1) begin
            next_state <= S0;
            match <= 1'b1;
          end else begin
            next_state <= S0;
          end
        end
        default: begin
          next_state <= S0;
        end
      endcase
    end
  end
  
endmodule