module top_module(n__390, b__6, a__5, a__4, b__2, c, a__0, b__1, a__3);output n__390;
	wire n553, n424, n__71, n612, n__39, n616, n572, n__8, n649, n576;
	input b__6, a__5, a__4, b__2, c, a__0, b__1, a__3;
  assign n__390 = ~(n424 | n553);
  assign n424 = ~b__6;
  assign n553 = ~(a__5 & n__71);
  assign n__71 = ~n612;
  assign n612 = ~(n__39 & a__4);
  assign n__39 = ~(n572 | n616);
  assign n572 = ~(n__8 & b__2);
  assign n__8 = ~(n576 | n649);
  assign n576 = ~(a__0 & c);
  assign n649 = ~b__1;
  assign n616 = ~a__3;
endmodule