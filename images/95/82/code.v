module top_module(A, B, C, D, E, F, G, H, EQ, GT);input A, B, C, D, E, F, G, H;
  output EQ, GT;

  wire a_eq_b, a_gt_b, b_gt_a;

  assign a_eq_b = (A == E) && (B == F) && (C == G) && (D == H);
  assign a_gt_b = (A > E) || ((A == E) && ((B > F) || ((B == F) && ((C > G) || ((C == G) && (D >= H))))));
  assign b_gt_a = (A < E) || ((A == E) && ((B < F) || ((B == F) && ((C < G) || ((C == G) && (D <= H))))));

  assign EQ = a_eq_b;
  assign GT = a_gt_b;
endmodule