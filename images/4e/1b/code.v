module sr_latch (
  input S,
  input R,
  output Q);reg Q;
always @* begin
  if (R)
    Q = 0;
  else if (S)
    Q = 1;
end

endmodule