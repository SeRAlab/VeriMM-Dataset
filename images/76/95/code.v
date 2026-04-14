module top_module(sign, _sign);input [9:0] sign;
	output [31:0] _sign;
	assign _sign[9:0] = sign[9:0]; 
	genvar i;
	
	for(i=10; i<32; i=i+1)
		assign _sign[i] = sign[9];

endmodule