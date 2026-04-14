module top_module(
  input A,
  input B,
  input Cin,
  output S,
  output Cout
);// XOR gate function
  function [0:0] XOR;
    input [0:0] a, b;
    begin
      XOR = a ^ b;
    end
  endfunction
  
  // OR gate function
  function [0:0] OR;
    input [0:0] a, b;
    begin
      OR = a | b;
    end
  endfunction
  
  // AND gate function
  function [0:0] AND;
    input [0:0] a, b;
    begin
      AND = a & b;
    end
  endfunction
  
  // Compute sum output (S)
  assign S = XOR(XOR(A, B), Cin);
  
  // Compute carry-out output (Cout)
  assign Cout = OR(AND(A, B), AND(Cin, XOR(A, B)));
  
endmodule