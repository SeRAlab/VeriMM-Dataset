module top_module(n__138, a__5, a__4, b__3, a__2, a__1, b__1);output n__138;
	wire n550, n__74, n609, n__42, n627, n631, n__3, n649, n645;
	input a__5, a__4, b__3, a__2, a__1, b__1;
  assign n__138 = ~n550;
  assign n550 = ~(a__5 & n__74);
  assign n__74 = ~n609;
  assign n609 = ~(n__42 & a__4);
  assign n__42 = ~(n631 | n627);
  assign n631 = ~b__3;
  assign n627 = ~(a__2 & n__3);
  assign n__3 = ~(n645 | n649);
  assign n645 = ~a__1;
  assign n649 = ~b__1;
endmodule