module top_module(n__35, b__2, b__0, a__0, a__1, a__3);output n__35;
	wire n616, n577, n__4, n645, n647;
	input b__2, b__0, a__0, a__1, a__3;
  assign n__35 = ~(n577 | n616);
  assign n577 = ~(n__4 & b__2);
  assign n__4 = ~(n647 | n645);
  assign n647 = ~(a__0 & b__0);
  assign n645 = ~a__1;
  assign n616 = ~a__3;
endmodule