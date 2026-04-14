module decoder_5to32(
	input 			clk		,
	input 			rst		,
	input 			enable	,
	input	[4:0]	in		,

	output reg [31:0] out
);

always@(posedge clk or negedge rst)
begin
	if(!rst)
		out <= 32'b0;
	else if(enable)
		out <= 32'b1 << in;
	else
		out <= 32'b0;
end

endmodule