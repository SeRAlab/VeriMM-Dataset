module top_module(
	input		clk,
	input		rst_n,
	input 	input_model,
	
	output   out_spike
);reg	[7:0]cnt1;

always@(posedge clk or negedge rst_n)begin
	if(!rst_n)
		cnt1 <= 8'd0;
	else if(cnt1 < 8'd7 && input_model == 1'b1)
		cnt1 <= cnt1 + 8'd1;
	else 
		cnt1 <= 8'b0;
end

assign out_spike = (cnt1 == 8'd2)?1:0;

endmodule