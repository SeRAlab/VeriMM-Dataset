module top_module(n__115, b__4, b__2, a__1, b__0, c, b__3);output n__115;
	wire n636, n__52, n631, n574, n__6, n570, n645;
	input b__4, b__2, a__1, b__0, c, b__3;
  assign n__115 = ~n636;
  assign n636 = ~(n__52 & b__4);
  assign n__52 = ~(n574 | n631);
  assign n574 = ~(n__6 & b__2);
  assign n__6 = ~(n645 | n570);
  assign n645 = ~a__1;
  assign n570 = ~(c & b__0);
  assign n631 = ~b__3;
endmodule