module top_module(n__258, a__5, a__4, b__2, a__1, b__1, a__3, a__6);output n__258;
	wire n433, n558, n__66, n618, n__34, n616, n578, n__3, n649, n645;
	input a__5, a__4, b__2, a__1, b__1, a__3, a__6;
  assign n__258 = ~(n558 | n433);
  assign n558 = ~(a__5 & n__66);
  assign n__66 = ~n618;
  assign n618 = ~(a__4 & n__34);
  assign n__34 = ~(n578 | n616);
  assign n578 = ~(n__3 & b__2);
  assign n__3 = ~(n645 | n649);
  assign n645 = ~a__1;
  assign n649 = ~b__1;
  assign n616 = ~a__3;
  assign n433 = ~a__6;
endmodule