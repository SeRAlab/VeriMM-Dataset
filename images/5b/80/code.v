module top_module(
	input	clk_1,
	input	times_count,
	input	switch,
	output	reg [9:0]	speed,
	output	reg	dig_show
);reg [15:0]	count=0;
reg [15:0]	count_old=0;

always @	(posedge	times_count)begin
	count<=count+1;
end

always @	(posedge clk_1)
	begin
		if(switch==0)
			begin
				speed<=0;
				dig_show<=0;
			end
		else
			begin
				speed<=count-count_old;
				count_old<=count;
				dig_show<=1;
			end 
	end
endmodule