module top_module(
  input clk,
  input reset,
  input A,
  input B,
  output reg C
);parameter S0 = 3'b000;
  parameter S1 = 3'b001;
  parameter S2 = 3'b010;
  parameter S3 = 3'b011;
  parameter S4 = 3'b100;
  parameter S5 = 3'b101;
  parameter S6 = 3'b110;
  parameter S7 = 3'b111;
  
  reg [2:0] state;
  
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= S0;
      C <= 0;
    end else begin
      case (state)
        S0: begin
          if (A == 0 && B == 0) begin
            state <= S1;
          end
        end
        S1: begin
          if (A == 0 && B == 1) begin
            state <= S2;
          end
        end
        S2: begin
          if (A == 1 && B == 0) begin
            state <= S3;
          end
        end
        S3: begin
          if (A == 1 && B == 1) begin
            state <= S0;
          end
        end
      endcase
      
      if (state == S1 || state == S2) begin
        C <= 1;
      end else begin
        C <= 0;
      end
    end
  end
  
endmodule