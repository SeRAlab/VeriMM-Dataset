module top_module(
	pi0, pi1, pi2, pi3, pi4,
	po0);input pi0, pi1, pi2, pi3, pi4;
  	output po0;
  	wire n1, n2, n3;
	assign n1 = pi0 | pi1;
	assign n2 = pi2 | pi3;
	assign n3 = n1 | pi4;
	assign po0 = n3 & n2;
endmodule