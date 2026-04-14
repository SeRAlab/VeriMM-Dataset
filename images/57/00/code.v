module top_module(data1_i, data2_i, data_o);input	[31:0] 	data1_i, data2_i;
	output			data_o;

	reg				data_o;

	always @(*)
		begin
			if (data1_i == data2_i)
				data_o <= 1'b1;
			else data_o <= 1'b0;
		end
endmodule