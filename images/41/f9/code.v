module top_module(n__359, b__5, b__4, b__3, b__2, a__2, a__6);output n__359;
	wire n441, n457, n__104, n650, n__41, n629, n631;
	input b__5, b__4, b__3, b__2, a__2, a__6;
  assign n__359 = ~(n457 | n441);
  assign n457 = ~(n__104 & b__5);
  assign n__104 = ~n650;
  assign n650 = ~(n__41 & b__4);
  assign n__41 = ~(n631 | n629);
  assign n631 = ~b__3;
  assign n629 = ~(a__2 & b__2);
  assign n441 = ~a__6;
endmodule