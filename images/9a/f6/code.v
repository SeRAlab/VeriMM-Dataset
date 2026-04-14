module top_module(n__274, a__5, a__4, b__3, b__2, b__0, a__0, a__1, a__6);output n__274;
	wire n435, n542, n__82, n600, n__50, n577, n631, n__4, n645, n647;
	input a__5, a__4, b__3, b__2, b__0, a__0, a__1, a__6;
  assign n__274 = ~(n542 | n435);
  assign n542 = ~(a__5 & n__82);
  assign n__82 = ~n600;
  assign n600 = ~(n__50 & a__4);
  assign n__50 = ~(n631 | n577);
  assign n631 = ~b__3;
  assign n577 = ~(n__4 & b__2);
  assign n__4 = ~(n647 | n645);
  assign n647 = ~(a__0 & b__0);
  assign n645 = ~a__1;
  assign n435 = ~a__6;
endmodule