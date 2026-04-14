module top_module(A, B, C, Y);specify                 
    specparam tpdh = 15;
    specparam tpdl = 15;
    (A *> Y) = (tpdh, tpdl);
    (B *> Y) = (tpdh, tpdl);
    (C *> Y) = (tpdh, tpdl);
  endspecify  
  input A;
  input B;
  input C;
  output Y;

  assign Y = ~(A|B|C);endmodule