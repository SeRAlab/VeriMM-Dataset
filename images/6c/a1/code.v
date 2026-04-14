module top_module(
  input clk,
  input reset,
  input data_in,
  input enable,
  output reg data_out,
  output reg valid_out
);// Define the states using one-hot encoding
  parameter S0 = 4'b0001;
  parameter S1 = 4'b0010;
  parameter S2 = 4'b0100;
  parameter S3 = 4'b1000;
  
  // Define the state register and next state logic
  reg [3:0] state, next_state;
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= next_state;
    end
  end
  
  // Define the output logic
  always @(*) begin
    case(state)
      S0: begin
        if (data_in) begin
          next_state = S0;
          data_out = 0;
        end else if (enable) begin
          next_state = S1;
          data_out = 0;
        end
      end
      S1: begin
        if (data_in) begin
          next_state = S0;
          data_out = 0;
        end else if (enable) begin
          next_state = S2;
          data_out = 0;
        end
      end
      S2: begin
        if (data_in) begin
          next_state = S0;
          data_out = 1;
        end else if (enable) begin
          next_state = S3;
          data_out = 0;
        end
      end
      S3: begin
        if (data_in) begin
          next_state = S0;
          data_out = 0;
        end else if (enable) begin
          next_state = S0;
          data_out = 0;
        end
      end
    endcase
    
    // Define the valid output signal
    if (state == S2 && data_in) begin
      valid_out = 1;
    end else begin
      valid_out = 0;
    end
  end

endmodule