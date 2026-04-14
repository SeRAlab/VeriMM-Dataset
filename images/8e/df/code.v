module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input sub,
  output reg [3:0] out
);always @(posedge clk, negedge reset) begin
    if (reset == 0) begin
      out <= 4'b0;
    end else begin
      if (sub == 0) begin
        out <= A + B;
      end else begin
        out <= A - B;
      end
    end
  end

endmodule