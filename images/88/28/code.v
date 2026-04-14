module top_module(
  input [31:0] x,
  input [31:0] y,
  output reg [31:0] result
);always @(*) begin
    if (y == 0) begin
      result <= 0;
    end else begin
      result <= x - (x / y) * y;
    end
  end

endmodule