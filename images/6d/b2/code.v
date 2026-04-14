module top_module(G, P, Gi, Pi, GiPrev, PiPrev);output G, P;
  input Gi, Pi, GiPrev, PiPrev;
  
  assign G = (Gi) | (Pi&GiPrev);
  assign P = Pi&PiPrev;endmodule