module top_module(
	data_i,
	data_o
);input [31:0] data_i;
output [31:0] data_o;

assign data_o[11:0] = (data_i[5] == 0) ? data_i[31:20] :
					  (data_i[6] == 0) ? {data_i[31:25],data_i[11:7]} : {data_i[31],data_i[7],data_i[30:25],data_i[11:8]};
assign data_o[31:12] = {20{data_i[31]}};

endmodule