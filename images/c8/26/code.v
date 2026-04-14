module karnaugh_map(
  input wire A, B, C,
  output reg F
);

// Boolean expression: F = !B*C + A*!C
always @(*) begin
  F = (!B&C) | (A&!C);
end

endmodule