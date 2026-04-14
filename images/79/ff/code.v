module top_module(
	ovalue,
	ivalue,
	amount
);parameter	LOGWORD=0;
	localparam	WORD=(1<<LOGWORD);
	
	output		reg			[WORD-1:0]								ovalue;	
	input					[WORD-1:0]								ivalue;	
	input					[LOGWORD-1:0]							amount;	
	
				reg			[WORD-1:0]								rank	[LOGWORD+1-1:0];	
	
	always @(*) begin
		rank[LOGWORD]	<=	ivalue;
	end
	
	genvar i;
	genvar j;
	generate
		for(i=0; i<LOGWORD; i=i+1) begin : i_right_shift		
			always @(*) begin
				if(amount[i]) begin
					rank[i]	<=	rank[i+1][WORD-1:(1<<i)];
				end
				else begin
					rank[i]	<=	rank[i+1];
				end
			end
		end
	endgenerate
	
	always @(*) begin
		ovalue	<=	rank[0];
	end
endmodule