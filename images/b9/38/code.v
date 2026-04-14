module top_module(
	input			clk,
	input			rstn,
	input	    [31:0]	afl,
	input	    [31:0]	bfl,
	output	reg [31:0]	fl
	);reg	[47:0]	mfl_0;		// Mantisa of the Float
reg		sfl_0;		// Sign of the Float
reg	[7:0]	efl_0;		// Exponent of the Float
reg		zero_out_0;
reg		sfl_1;		// Sign of the Float
reg	[7:0]	efl_1;		// Exponent of the Float
reg		zero_out_1;
reg		mfl47_1;	// Mantisa of the Float
reg	[24:0]	nmfl_1;		// Normalized Mantisa of the Float
reg 		not_mfl_47;

always @* not_mfl_47 = (~mfl47_1 & ~nmfl_1[24]);

always @(posedge clk, negedge rstn) begin
	if(!rstn) begin
		mfl_0 	   <= 48'h0;
		sfl_0 	   <= 1'b0;
		efl_0 	   <= 8'h0;
		zero_out_0 <= 1'b0;
		efl_1 	   <= 8'h0;
		sfl_1 	   <= 1'b0;
		zero_out_1 <= 1'b0;
		mfl47_1    <= 1'b0;
		nmfl_1     <= 25'h0;
		fl 	   <= 32'h0;
	end
	else begin
		// Pipe 0.
		// Multiply the mantisa.
		mfl_0 <= {1'b1,afl[22:0]} * {1'b1,bfl[22:0]};
		// Calulate the Sign.
		sfl_0 <= afl[31] ^ bfl[31];
		efl_0 <= afl[30:23] + bfl[30:23] - 8'h7E;
		// If a or b equals zero, return zero.
		if((afl[30:0] == 0) || (bfl[30:0] == 0))zero_out_0 <= 1'b1;
		else zero_out_0 <= 1'b0;
		// Pipe 1.
		efl_1 <= efl_0;	
		sfl_1 <= sfl_0;	
		zero_out_1 <= zero_out_0;
		mfl47_1  <= mfl_0[47];
		if(mfl_0[47]) nmfl_1 <= mfl_0[47:24] + mfl_0[23];
		else 	      nmfl_1 <= mfl_0[47:23] + mfl_0[22];
		// Pipe 2.
		if(zero_out_1) fl <= 32'h0;
		else 	       fl <= {sfl_1,(efl_1 - not_mfl_47),nmfl_1[22:0]};
	end
end

endmodule