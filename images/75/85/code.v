module top_module(n__212, b__5, a__4, b__2, b__0, a__0, b__1, b__3);output n__212;
	wire n476, n__85, n597, n__53, n631, n573, n__7, n649, n647;
	input b__5, a__4, b__2, b__0, a__0, b__1, b__3;
  assign n__212 = ~n476;
  assign n476 = ~(n__85 & b__5);
  assign n__85 = ~n597;
  assign n597 = ~(n__53 & a__4);
  assign n__53 = ~(n573 | n631);
  assign n573 = ~(n__7 & b__2);
  assign n__7 = ~(n647 | n649);
  assign n647 = ~(a__0 & b__0);
  assign n649 = ~b__1;
  assign n631 = ~b__3;
endmodule