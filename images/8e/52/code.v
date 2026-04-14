module top_module(
	data0_i, data1_i, data2_i,
	select_i,
	data_o
);input		[31:0]	data0_i, data1_i, data2_i;
input		[1:0]	select_i;
output	reg	[31:0]	data_o;

always @(*) begin
	if (select_i == 2'b00)
		data_o <= data0_i;
	else if (select_i == 2'b01)
		data_o <= data1_i;
	else if (select_i == 2'b10)
		data_o <= data2_i;
	else
		data_o <= data0_i;
end


endmodule