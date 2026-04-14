module comparator(
    input [3:0] a,
    input [3:0] b,

    output eq
);

reg eq;

always @(*)
begin
  if (a == b)
    eq = 1'b1;
  else
    eq = 1'b0;
end

endmodule