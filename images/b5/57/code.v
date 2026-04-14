module top_module(
  input clk,
  input reset,
  input a,
  input b,
  input c,
  output reg out1,
  output reg out2
);// Define the states
  parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;

  // Define the state register
  reg [1:0] state;

  // Define the next state logic
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
    end else begin
      case (state)
        S0: begin
          if (a) begin
            state <= S2;
          end else begin
            state <= S1;
          end
        end
        S1: begin
          if (b) begin
            state <= S3;
          end else begin
            state <= S0;
          end
        end
        S2: begin
          if (c) begin
            state <= S0;
          end else begin
            state <= S3;
          end
        end
        S3: begin
          if (reset) begin
            state <= S0;
          end else begin
            state <= S3;
          end
        end
      endcase
    end
  end

  // Define the output logic
  always @(state, a, b, c) begin
    case (state)
      S0: begin
        out1 <= 1'b0;
        out2 <= 1'b0;
      end
      S1: begin
        out1 <= 1'b0;
        out2 <= 1'b1;
      end
      S2: begin
        out1 <= 1'b1;
        out2 <= 1'b0;
      end
      S3: begin
        out1 <= 1'b1;
        out2 <= 1'b1;
      end
    endcase
  end

endmodule