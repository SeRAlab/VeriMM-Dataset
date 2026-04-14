module top_module(
  input clk,
  input reset,
  input in1,
  input in2,
  input in3,
  input in4,
  output reg out1,
  output reg out2
);parameter S0 = 4'b0001, S1 = 4'b0010, S2 = 4'b0100, S3 = 4'b1000;
  reg [3:0] state, next_state;
  
  always @(posedge clk, negedge reset) begin
    if (reset == 1'b0) begin
      state <= S0;
    end
    else begin
      state <= next_state;
    end
  end
  
  always @(*) begin
    case(state)
      S0: begin
        next_state = (in1 == 1'b1) ? S1 : S0;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      S1: begin
        next_state = (in3 == 1'b1) ? S2 : S1;
        out1 = 1'b1;
        out2 = 1'b0;
      end
      S2: begin
        next_state = (in4 == 1'b1) ? S3 : S2;
        out1 = 1'b0;
        out2 = 1'b1;
      end
      S3: begin
        next_state = (in1 == 1'b0) ? S0 : S3;
        out1 = 1'b0;
        out2 = 1'b0;
      end
      default: begin
        next_state = S0;
        out1 = 1'b0;
        out2 = 1'b0;
      end
    endcase
  end
  
endmodule