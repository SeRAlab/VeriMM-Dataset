module top_module(inp, rout_0, rout_1, rout_2, rout_3, iout_0, iout_1, iout_2, iout_3);input [3:0] inp; 
	output [2:0] rout_0;
	output [2:0] rout_1;
	output [2:0] rout_2;
	output [2:0] rout_3;
	
	output [2:0] iout_0;
	output [2:0] iout_1;
	output [2:0] iout_2;
	output [2:0] iout_3;
	
	wire [2:0] fft1_0;
	wire [2:0] fft1_1;
	wire [2:0] fft2_0;
	wire [2:0] fft2_1;

	
	assign fft1_0 = inp[0] + inp[2];
	assign fft1_1 = inp[0] - inp[2];
	assign fft2_0 = inp[1] + inp[3];
	assign fft2_1 = inp[1] - inp[3];
	
	
	assign rout_0 = fft1_0 + fft2_0;
	assign iout_0 = 0;

	assign rout_1 = fft1_1;
	assign iout_1 = 0 - fft2_1;

	assign rout_2 = fft1_0 - fft2_0;
	assign iout_2 = 0;

	assign rout_3 = fft1_1;
	assign iout_3 = fft2_1;

endmodule