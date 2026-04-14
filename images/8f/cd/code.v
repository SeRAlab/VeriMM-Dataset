module top_module(
	
	
	
	input wire [15:0] data,
	input wire carry,
	

	
	
	
	output wire zd_flag,
	output wire carry_flag,
	output wire overflow_flag,
	output wire negative_flag
	
	);assign zd_flag = (data == 16'b0000000000000000);
	assign carry_flag = carry;
	assign overflow_flag = ({carry,data[15]} == 2'b01);
	assign negative_flag = (data[15] == 1'b1);


endmodule