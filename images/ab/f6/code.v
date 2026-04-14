module top_module(n__132, a__5, a__4, a__3, b__2, a__1, c, a__0);output n__132;
	wire n556, n__68, n615, n__36, n575, n616, n__5, n576, n645;
	input a__5, a__4, a__3, b__2, a__1, c, a__0;
  assign n__132 = ~n556;
  assign n556 = ~(a__5 & n__68);
  assign n__68 = ~n615;
  assign n615 = ~(a__4 & n__36);
  assign n__36 = ~(n616 | n575);
  assign n616 = ~a__3;
  assign n575 = ~(b__2 & n__5);
  assign n__5 = ~(n645 | n576);
  assign n645 = ~a__1;
  assign n576 = ~(a__0 & c);
endmodule