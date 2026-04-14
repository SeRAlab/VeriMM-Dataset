module top_module(
	/* verilator lint_off UNUSED */
	clk,
	enable,
	srca,
	srcb,
	dst
);parameter PRECISE_FMUL = 1;

input           clk;
input           enable;
input[63:0]     srca;
input[63:0]     srcb;
output[63:0]    dst;

reg sgna;
reg sgnb;
reg sgnc;

reg[12:0] exa;
reg[12:0] exb;
reg[12:0] exc;

`ifdef PRECISE_FMUL
reg[105:0] tFracA;
reg[105:0] tFracB;
reg[105:0] tFracC1;
reg[63:0]  tFracC;
`else
reg[63:0]  tFracA;
reg[63:0]  tFracB;
reg[63:0]  tFracC;
`endif

reg[51:0] tFracC2;
reg[63:0] tDst; // Declare tDst as a register

// Determine the sign of each input number
always @ (srca, srcb)
begin
	sgna = srca[63];
	sgnb = srcb[63];
end

// Extract the exponent of each input number
always @ (srca, srcb)
begin
	exa[10:0] = srca[62:52];
	exb[10:0] = srcb[62:52];
	exa[12:11] = 0;
	exb[12:11] = 0;
end

// Extract the fraction of each input number
always @ (srca, srcb)
begin
`ifdef PRECISE_FMUL
	tFracA[105:52] = 1;
	tFracB[105:52] = 1;
`else
	tFracA[63:52] = 1;
	tFracB[63:52] = 1;
`endif
	tFracA[51:0] = srca[51:0];
	tFracB[51:0] = srcb[51:0];
end

// Multiply the fractions together
always @ (srca, srcb)
begin
`ifdef PRECISE_FMUL
	tFracC1 = tFracA * tFracB;
	tFracC = tFracC1[105:42] + 64'h3FF;
`else	
	tFracC = (tFracA >> 21) * (tFracB >> 21);
`endif
end

// Determine the sign of the output number
always @ (sgna, sgnb)
begin
	sgnc = sgna ^ sgnb;
end

// Determine the exponent of the output number
always @ (exa, exb, tFracC)
begin
	if(tFracC[63])
	begin
		tFracC2[51:0] = tFracC[62:11];
		exc = exa + exb - 1022;
	end
	else
	begin
		tFracC2[51:0] = tFracC[61:10];
		exc = exa + exb - 1023;
	end
end

// Determine the fraction of the output number
always @ (tFracC)
begin
	tFracC2[51:0] = tFracC[61:10];
end

// Combine the sign, exponent, and fraction to get the output number
always @ (sgnc, exc, tFracC2)
begin
	if(exc[12])
	begin
		tDst = 0;
	end
	else if(exc[11])
	begin
		tDst[63] = sgnc;
		tDst[62:0] = 63'h7FF0_0000_0000_0000;
	end
	else
	begin
		tDst[63] = sgnc;
		tDst[62:52] = exc[10:0];
		tDst[51:0] = tFracC2[51:0];
	end
end

assign dst = tDst;

endmodule