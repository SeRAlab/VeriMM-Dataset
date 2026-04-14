module	shift_1b(
input	i_shift,
input	[31:0]i_data,
output	[31:0]o_data
);
assign	o_data=i_shift?{i_data[30:0],1'b0}:i_data;
endmodule