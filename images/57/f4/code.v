module top_module(
  input [2:0] A,
  input [2:0] B,
  output reg eq,
  output reg gt
);always @(*) begin
    if (A == B) begin
      eq = 1;
      gt = 0;
    end else if (A > B) begin
      eq = 0;
      gt = 1;
    end else begin
      eq = 0;
      gt = 0;
    end
  end

endmodule