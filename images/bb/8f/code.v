module top_module(n__475, b__6, b__5, b__4, a__2, a__1, b__0, c, a__3);output n__475;
	wire n468, n430, n__93, n588, n__30, n616, n596, n__6, n570, n645;
	input b__6, b__5, b__4, a__2, a__1, b__0, c, a__3;
  assign n__475 = ~(n430 | n468);
  assign n430 = ~b__6;
  assign n468 = ~(n__93 & b__5);
  assign n__93 = ~n588;
  assign n588 = ~(n__30 & b__4);
  assign n__30 = ~(n596 | n616);
  assign n596 = ~(n__6 & a__2);
  assign n__6 = ~(n645 | n570);
  assign n645 = ~a__1;
  assign n570 = ~(c & b__0);
  assign n616 = ~a__3;
endmodule