module top_module(
  output Q,
  input S0, S1, A, B, C, D
);specify
    (S0 => Q) = 1251; 
    (S1 => Q) = 1406; 
    (A => Q) = 1699;  
    (B => Q) = 1687;  
    (C => Q) = 1669;  
    (D => Q) = 1679;  
  endspecify

  assign Q = S1 ? (S0 ? D : C) : (S0 ? B : A);
endmodule