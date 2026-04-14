module top_module(
    input h1,
    input h2,
    input h3,
	 input p,
	 input sign,
    output Q1H,
    output Q1L,
    output Q2H,
    output Q2L,
    output Q3H,
    output Q3L
    );assign Q1H= sign? (h2||(~h1)):(h1||(~h2));
	 assign Q1L= sign? (p&(h2&(~h1))): (p&(h1&(~h2)));
	 assign Q2H= sign? (h3||(~h2)):(h2||(~h3));
	 assign Q2L= sign? (p&(h3&(~h2))): (p&(h2&(~h3)));
	 assign Q3H= sign? (h1||(~h3)):(h3||(~h1));
	 assign Q3L= sign? (p&(h1&(~h3))): (p&(h3&(~h1)));
endmodule