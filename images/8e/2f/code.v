module top_module(
	
	input  iReset,
	input  iClk,

	input  iLoad,
	input  iEnable,
	input  [WORDSIZE-1:0] iCounter,
	output [WORDSIZE-1:0] oCounter,

	output oReady
);parameter WORDSIZE = 8;

wire wZeroCount;

reg [WORDSIZE-1:0] rCounter;

always @ (posedge iReset or posedge iClk)
begin
	if(iReset) 
		rCounter <= 0;
	else
	begin
		if(iLoad)
			rCounter <= iCounter - 1'b1;
		else
		begin
			if(iEnable)
			begin
				if(!wZeroCount)
					rCounter <= rCounter - 1'b1;
				else
					rCounter <= iCounter - 1'b1;
			end
		end
	end
end

assign wZeroCount = ~|rCounter; 

assign oReady   = (wZeroCount && iEnable)? 1'b1: 1'b0;
assign oCounter = rCounter;

endmodule