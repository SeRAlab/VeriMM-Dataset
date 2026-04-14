module top_module(data_in_A, data_in_B, cmp_rslt);parameter DATA_WIDTH = 14;
	 
	 input [DATA_WIDTH - 1:0] data_in_A, data_in_B;
    output cmp_rslt; 

    assign cmp_rslt = (data_in_A == data_in_B) ? 1'b1 : 1'b0;
endmodule