module top_module(
	input  [0:1] KEY, 
	output [7:0] HEX0, 
	output [7:0] HEX1, 
	output [7:0] HEX2, 
	output [7:0] HEX3, 
	output [7:0] HEX4, 
	output [7:0] HEX5	
);genvar i;
generate 
	for(i = 0; i < 6; i=i+1)
	begin: bday
		case(i)
		0: assign HEX0[5] = ~KEY[0],  HEX0[2] = ~KEY[0], HEX0[7] = ~KEY[0];
		1: assign HEX1[6] = ~KEY[0], HEX1[7] = ~KEY[0];
		2: assign HEX2[1] = ~KEY[0], HEX2[4] = ~KEY[0];
		3: assign HEX3[6] = ~KEY[0], HEX3[2] = ~KEY[0], HEX3[7] = ~KEY[0];
		4: assign HEX4[3] = ~KEY[0], HEX4[4] = ~KEY[0], HEX4[5] = ~KEY[0], HEX4[6] = ~KEY[0];
		5: assign HEX5[6] = ~KEY[0],  HEX5[7] = ~KEY[0];
		endcase
	end
endgenerate
endmodule