module top_module(
    input a,
    input b,
    input sel,
    output reg y  // Change output to reg type
);always @ (a, b, sel)
  begin
    if (sel == 0)
      y = a;
    else
      y = b;
  end
  
endmodule