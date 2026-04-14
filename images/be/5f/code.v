module top_module(
  input clk,
  input reset,
  input in1,
  input in2,
  input in3,
  output reg out1,
  output reg out2
);parameter S0 = 2'b00;
  parameter S1 = 2'b01;
  parameter S2 = 2'b10;
  parameter S3 = 2'b11;
  
  reg [1:0] state, state_next;
  
  always @(posedge clk) begin
    if (reset) begin
      state <= S0;
    end else begin
      state <= state_next;
    end
  end
  
  always @(*) begin
    case(state)
      S0: begin
        state_next = (in1 & in2) | reset ? S1 : S0;
        out1 = 1'b0;
        out2 = state_next == S3 ? 1'b1 : 1'b0;
      end
      S1: begin
        state_next = in1 & in3 ? S2 : S0;
        out1 = 1'b1;
        out2 = state_next == S3 ? 1'b1 : 1'b0;
      end
      S2: begin
        state_next = in2 & !in3 ? S3 : S0;
        out1 = 1'b1;
        out2 = state_next == S3 ? 1'b1 : 1'b0;
      end
      S3: begin
        state_next = (!in1 & in3) | reset ? S1 : S0;
        out1 = 1'b0;
        out2 = state_next == S3 ? 1'b1 : 1'b0;
      end
    endcase
  end
  
endmodule