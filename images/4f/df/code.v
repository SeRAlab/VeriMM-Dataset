module barrel_shifter (
	input [7:0] data,
	input [2:0] shift,
	output [7:0] out
);assign out = (shift == 3'b000) ? data :
			(shift == 3'b001) ? {data[6:0], 1'b0} :
			(shift == 3'b010) ? {data[5:0], 2'b00} :
			(shift == 3'b011) ? {data[4:0], 3'b000} :
			(shift == 3'b100) ? {data[3:0], 4'b0000} :
			(shift == 3'b101) ? {data[2:0], 5'b00000} :
			(shift == 3'b110) ? {data[1:0], 6'b000000} :
			{data[0], 7'b0000000};

endmodule