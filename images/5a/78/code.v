module top_module(A, B, Y);specify             
    specparam tpdh = 15;
    specparam tpdl = 15;
    (A *> Y) = (tpdh, tpdl);
    (B *> Y) = (tpdh, tpdl);
  endspecify  
  input A;
  input B;
  output Y;

  assign Y = ~(A|B);endmodule