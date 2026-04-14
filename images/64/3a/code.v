module top_module(
	input  		 clk,
	input [15:0] DAC_in,
	output 	 	 audio_out
);reg [16:0] DAC_Register;
	always @(posedge clk) DAC_Register <= DAC_Register[15:0] + DAC_in;
	assign audio_out = DAC_Register[16];

// --------------------------------------------------------------------
endmodule