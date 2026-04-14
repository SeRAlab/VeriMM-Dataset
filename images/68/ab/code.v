module top_module(
    output Q,
    input  S,
    A,
    B
);specify
    (S => Q) = 698;  
    (A => Q) = 639;  
    (B => Q) = 639;  
  endspecify

  assign Q = S ? B : A;
endmodule