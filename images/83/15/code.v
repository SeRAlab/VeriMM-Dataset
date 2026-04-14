module top_module(n__176, a__5, b__4, b__3, b__2, a__1, b__1);output n__176;
	wire n512, n__112, n639, n__49, n578, n631, n__3, n649, n645;
	input a__5, b__4, b__3, b__2, a__1, b__1;
  assign n__176 = ~n512;
  assign n512 = ~(a__5 & n__112);
  assign n__112 = ~n639;
  assign n639 = ~(n__49 & b__4);
  assign n__49 = ~(n631 | n578);
  assign n631 = ~b__3;
  assign n578 = ~(n__3 & b__2);
  assign n__3 = ~(n645 | n649);
  assign n645 = ~a__1;
  assign n649 = ~b__1;
endmodule