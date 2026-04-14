module top_module(O, I0, I1, S0);input I0,I1;
  input S0;
  output O;

	specify
		(I0 => O) = (141, 160);
		(I1 => O) = (141, 160);
		(S0 => O) = (486, 680);
	endspecify

  assign O = S0 ? I1 : I0;
endmodule