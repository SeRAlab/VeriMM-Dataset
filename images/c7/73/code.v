module mux2to1 (
    input a,
    input b,
    input sel,
    output y
  );
  
  always @ (a, b, sel)
  begin
    if (sel == 0)
      y = a;
    else
      y = b;
  end
  
endmodule