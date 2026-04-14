module mux4to1 (
  input A,
  input B,
  input C,
  input D,
  input sel0,
  input sel1,
  output reg Y
);

  always @(*)
  begin
    if(sel0 == 0 && sel1 == 0)
      Y = A;
    else if(sel0 == 0 && sel1 == 1)
      Y = B;
    else if(sel0 == 1 && sel1 == 0)
      Y = C;
    else if(sel0 == 1 && sel1 == 1)
      Y = D;
  end

endmodule
