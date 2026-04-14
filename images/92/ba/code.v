module mux_2to1(
    input in0,
    input in1,
    input sel,
    output out
);

reg out;

always@(*)
begin
  if(sel)
    out = in1;
  else
    out = in0;
end

endmodule