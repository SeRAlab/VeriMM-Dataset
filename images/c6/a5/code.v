module compare (
  input [7:0] A,
  input [7:0] B,
  output reg [15:0] result
);

always @(*)
begin
  if (A >= B)
    result = A + B;
  else
    result = B - A;
end

endmodule