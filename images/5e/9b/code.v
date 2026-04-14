module top_module(sel, A0, A1, Z);parameter WIDTH = 8;
  input sel;
  input [WIDTH-1:0] A0, A1;
  output reg[WIDTH-1:0] Z;
  
  always @(sel or A0 or A1)
    begin
    if(sel == 1)
      Z = A1;
    else
      Z = A0;
  end
endmodule