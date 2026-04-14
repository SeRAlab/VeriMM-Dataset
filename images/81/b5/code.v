module top_module(mRed_b, mGreen_b, mBlue_b, mRed_a, mGreen_a, mBlue_a, toggle_red, toggle_green, toggle_blue);input [9:0] mRed_b, mGreen_b, mBlue_b;
	input toggle_red, toggle_green, toggle_blue;
	
	output reg [9:0] mRed_a, mGreen_a, mBlue_a;
	
	always @(*)
	begin
		if (toggle_red)
			mRed_a = mRed_b;
		else
			mRed_a = 0;
			
		if (toggle_green)
			mGreen_a = mGreen_b;
		else
			mGreen_a = 0;
			
		if (toggle_blue)
			mBlue_a = mBlue_b;
		else
			mBlue_a = 0;
	end
	
endmodule