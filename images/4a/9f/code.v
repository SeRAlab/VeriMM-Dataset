module top_module(All, Blink, Right, Left);input All, Blink;
output Right, Left;

	assign Right = !(!All&Blink);
	assign Left = All | Blink;
endmodule