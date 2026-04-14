module top_module(
  input clk,
  input reset,
  input in,
  output reg [2:0] count
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;

  // Define the state register and initialize it to S0
  reg [1:0] state = S0;

  // Define the count register and initialize it to 0
  reg [2:0] consecutive_ones = 3'd0;

  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
      consecutive_ones <= 3'd0;
    end else begin
      case(state)
        S0: begin
          if (in) begin
            state <= S1;
            consecutive_ones <= 3'd1;
          end else begin
            state <= S0;
            consecutive_ones <= 3'd0;
          end
        end
        S1: begin
          if (in) begin
            state <= S2;
            consecutive_ones <= consecutive_ones + 1;
          end else begin
            state <= S0;
            consecutive_ones <= 3'd0;
          end
        end
        S2: begin
          state <= S0;
          count <= consecutive_ones;
          consecutive_ones <= 3'd0;
        end
      endcase
    end
  end

endmodule