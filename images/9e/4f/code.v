module t_ff(
    input clk,
    input clr,
    input t,

    output q
);

reg q;

always @(posedge clk or posedge clr)
begin
  if (clr)
    q <= 1'b0;
  else if (t)
    q <= ~q;
end

endmodule