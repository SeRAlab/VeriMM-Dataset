module top_module(ascii, number);input[7:0] ascii;
	output[31:0] number;
	assign number[31:8] = 24'h000000;
	assign number[7:0] = ascii - 8'h30;
	
endmodule