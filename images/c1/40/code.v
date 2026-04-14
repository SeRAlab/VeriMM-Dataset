module jt51_sum_op(
	input 		clk,
	input		zero,
	input		en_ch,
	input	signed	[13:0] op_out,
	output reg signed	[15:0] out
);
reg	signed [18:0]	sum;
always @(posedge clk) 
	if( zero ) begin
		sum <= en_ch ? op_out : 19'd0;
		if( sum[18:16]==3'd0 || sum[18:16]==3'b111 )
			out <= sum[15:0];
		else
			out<={ sum[18], {15{~sum[18]}}};
	end
	else
		if( en_ch ) sum <= sum + op_out;
endmodule