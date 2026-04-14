module Modulo (
  input [31:0] a,
  input [31:0] b,
  output reg [31:0] c
);

  always @(*) begin
    if (b == 0) begin
      c <= 0;
    end else if (a < b) begin
      c <= a;
    end else begin
      c <= a - (a / b) * b;
    end
  end

endmodule