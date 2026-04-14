module jt51_noise_lfsr #(parameter init=14220 )(
	input	rst,
	input	clk,
	input	base,
	output	out
);
reg [16:0] bb;
assign out = bb[16];
reg last_base;
always @(posedge clk) begin : base_counter
	if( rst ) begin
		bb			<= init[16:0];
		last_base 	<= 1'b0;
	end
	else begin
		last_base <= base;
		if( last_base != base ) begin	
			bb[16:1] 	<= bb[15:0];
			bb[0]		<= ~(bb[16]^bb[13]);
		end
	end
end
endmodule