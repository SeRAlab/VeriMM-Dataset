module top_module(n__248, a__5, b__4, a__4, a__6);output n__248;
	wire n433, n568, n__56, n632;
	input a__5, b__4, a__4, a__6;
  assign n__248 = ~(n568 | n433);
  assign n568 = ~(a__5 & n__56);
  assign n__56 = ~n632;
  assign n632 = ~(a__4 & b__4);
  assign n433 = ~a__6;
endmodule