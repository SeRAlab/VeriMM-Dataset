module top_module(
  input clk,
  input reset,
  input data,
  output reg match
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define the state register and initialize to S0
  reg [1:0] state = S0;

  // Define the next state logic
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= S0;
    end else begin
      case (state)
        S0: begin
          if (data == 1'b1) begin
            state <= S1;
          end else begin
            state <= S0;
          end
        end
        S1: begin
          if (data == 1'b1) begin
            state <= S2;
          end else begin
            state <= S0;
          end
        end
        S2: begin
          if (data == 1'b1) begin
            state <= S3;
          end else begin
            state <= S0;
          end
        end
        S3: begin
          if (data == 1'b1) begin
            state <= S0;
          end else begin
            state <= S3;
          end
        end
      endcase
    end
  end

  // Define the output logic
  always @(state, data) begin
    if (state == S3) begin
      match <= 1'b1;
    end else begin
      match <= 1'b0;
    end
  end

endmodule