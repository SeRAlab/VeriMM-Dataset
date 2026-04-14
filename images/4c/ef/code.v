module decoder3to8(
	input 	clk,
	input 	rst,
	input 	enable,
	input 	[2:0] input_data,
	output reg [7:0] output_data
);

always @(posedge clk or posedge rst)
begin
	if (rst)
		output_data <= 8'b0;
	else if (enable)
		output_data <= 1 << input_data;
	else
		output_data <= 8'b0;
end

endmodule