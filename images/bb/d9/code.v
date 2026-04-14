module top_module(
  input [3:0] A,
  input [3:0] B,
  output reg out_greater,
  output reg out_equal,
  output reg out_less
);always @ (A, B) begin
    if (A > B) begin
      out_greater = 1;
      out_equal = 0;
      out_less = 0;
    end else if (A == B) begin
      out_greater = 0;
      out_equal = 1;
      out_less = 0;
    end else begin
      out_greater = 0;
      out_equal = 0;
      out_less = 1;
    end
  end

endmodule