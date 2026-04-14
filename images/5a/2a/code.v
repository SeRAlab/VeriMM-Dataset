module top_module(
	input [11:0] imagPart,
	input [11:0] realPart,
	output reg [11:0] maximun);always @ * begin
		if(imagPart > realPart)
			maximun = imagPart;
		else
			maximun = realPart;
	end
endmodule