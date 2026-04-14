module top_module(
	data1_i,
	data2_i,
	select_i,
	data_o
);input	[31:0]	data1_i;
input	[31:0]	data2_i;
input			select_i;
output	[31:0]	data_o;

reg [31:0]	tmpdata_o;
assign data_o = tmpdata_o;

always @(*) begin
	if (select_i) begin
		tmpdata_o = data2_i;
	end
	else begin
		tmpdata_o = data1_i;
	end
end


endmodule