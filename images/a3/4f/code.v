module top_module(
	stall_i,
	clk_i,
	WB_i,
	ReadData_i,
	mux3_i,
	immed_i,
	WB_o,
	ReadData_o,
	mux3_o,	
	immed_o
);input			clk_i, stall_i;
input	[1:0]	WB_i;
input	[4:0]	mux3_i;
input	[31:0]	ReadData_i, immed_i;


output reg	[1:0]	WB_o;
output reg	[4:0]	mux3_o;
output reg	[31:0]	ReadData_o, immed_o;










always@(negedge clk_i)	begin
	if(stall_i)	begin
	end else begin
		WB_o <= WB_i;
		ReadData_o <= ReadData_i;
		immed_o <= immed_i;
		mux3_o <= mux3_i;
	end
end

endmodule