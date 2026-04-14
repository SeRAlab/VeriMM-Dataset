module top_module(A, Y);specify         
    specparam tpdh = 6.3;
    specparam tpdl = 5.5;
    (A *> Y) = (tpdh, tpdl);
  endspecify  
  input A;
  output Y;

  assign Y = ~A;endmodule