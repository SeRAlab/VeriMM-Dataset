module	ICAP_SPARTAN6(CLK, CE, WRITE, I, O, BUSY);
	input			CLK, CE, WRITE;
	input		[15:0]	I;
	output	wire	[15:0]	O;
	output	wire	BUSY;
	reg	[15:0]	rv;
	initial	rv = 16'h0000;
	always @(posedge CLK)
		if ((CE)&&(WRITE))
			rv <= I;
	assign	O = rv;
	assign	BUSY = 1'b0;
endmodule