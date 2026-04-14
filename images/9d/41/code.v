module up_down_counter(
	input 			clk		,
	input 			rst		,
	input			enable	,
	input			dir		,

	output reg [3:0] count
);

always@(posedge clk)
begin
	if(rst)
		count <= 4'b0000;
	else if(enable)
	begin
		if(dir)
			count <= count + 1;
		else
			count <= count - 1;
	end
end

endmodule