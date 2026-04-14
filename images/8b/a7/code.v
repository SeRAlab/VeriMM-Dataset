module top_module(A, B, Cin, Sel, Sum, Cout);input [3:0] A, B;
  input Cin, Sel;
  output [3:0] Sum;
  output Cout;

  wire [3:0] C;
  
  // Unsigned addition
  assign {Cout, Sum} = Cin + A + B;
  
  // Two's complement addition
  assign {Cout, Sum} = Cin + A + (~B) + 1'b1;

  // Select the appropriate addition based on Sel
  assign {Cout, Sum} = Sel ? {Cout, Sum} : {C[3], C[2], C[1], C[0]};
  
endmodule