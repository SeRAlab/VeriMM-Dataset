module top_module(
	input[1:0] RegDst,
	input[4:0] rt_D,
    input[4:0] rd_D,
    output[4:0] WAG
	);assign WAG = (RegDst==2'b00)?rt_D:
				 (RegDst==2'b01)?rd_D:
					 			5'd31;endmodule