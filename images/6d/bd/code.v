module top_module(p3, p2, p1, p0, g3, g2, g1, g0, c0, c1, c2, c3, c4, P, G);input p3, p2, p1, p0, g3, g2, g1, g0, c0;
  output c1, c2, c3, c4, P, G;
  
  
  assign #2 c1 = g0 | p0 & c0;
  assign #2 c2 = g1 | p1 & c1;
  assign #2 c3 = g2 | p2 & c2;
  assign #2 c4 = g3 | p3 & c3;
  
  
  assign #3 P = p3 & p2 & p1 & p0;
  assign #4 G = g3 | p3 & g2 | p3 & p2 & g1 | p3 & p2 & p1 & g0;endmodule