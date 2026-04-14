module top_module(
  input clk,
  input reset_n,
  input in1,
  input in2,
  output reg out
);parameter C = 2'b00, A = 2'b01, B = 2'b10;
  reg [1:0] state, next_state;
  
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      state <= C;
      out <= 0;
    end else begin
      state <= next_state;
      case (state)
        C: begin
          if (in1 == 1'b0 && in2 == 1'b0) begin
            next_state = A;
            out <= 0;
          end else if (in1 == 1'b0 && in2 == 1'b1) begin
            next_state = B;
            out <= 1;
          end else begin
            next_state = C;
            out <= 0;
          end
        end
        A: begin
          if (in1 == 1'b0 && in2 == 1'b0) begin
            next_state = C;
            out <= 0;
          end else if (in1 == 1'b0 && in2 == 1'b1) begin
            next_state = B;
            out <= 1;
          end else begin
            next_state = A;
            out <= 0;
          end
        end
        B: begin
          if (in1 == 1'b0 && in2 == 1'b0) begin
            next_state = A;
            out <= 1;
          end else if (in1 == 1'b0 && in2 == 1'b1) begin
            next_state = C;
            out <= 0;
          end else begin
            next_state = B;
            out <= 1;
          end
        end
      endcase
    end
  end
  
endmodule