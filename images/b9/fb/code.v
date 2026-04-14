module top_module(
  input clk,
  input reset,
  input x,
  input y,
  output reg out
);reg [1:0] state;
parameter A = 2'b00, B = 2'b01, C = 2'b10;

always @(posedge clk) begin
  if (reset) begin
    state <= A;
    out <= 1'b0;
  end else begin
    case (state)
      A: begin
        if (x) begin
          state <= B;
          out <= 1'b1;
        end else begin
          state <= A;
          out <= 1'b0;
        end
      end
      B: begin
        if (y) begin
          state <= C;
          out <= 1'b0;
        end else begin
          state <= B;
          out <= 1'b1;
        end
      end
      C: begin
        if (x) begin
          state <= A;
          out <= 1'b0;
        end else begin
          state <= B;
          out <= 1'b0;
        end
      end
    endcase
  end
end

endmodule