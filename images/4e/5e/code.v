module top_module(
  input wire A, B, C,
  output reg F
);// Boolean expression: F = !B*C + A*!C
always @(*) begin
  F = (!B&C) | (A&!C);
end

endmodule