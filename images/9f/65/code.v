module top_module(border, ActR, slug, slug_magenta, flash_blue, flash_GM, flash_RM, MC, MG, MR, Red, Green, Blue);input border;
	input ActR;
	input slug;
	input slug_magenta;
	input flash_blue;
	input flash_GM;
	input flash_RM;
	input [3:0] MC;
	input [3:0] MG;
	input [3:0] MR;



	output [2:0] Red;
	output [2:0] Green;
	output [1:0] Blue;



	assign Red[2] = ActR & (border | MC[0] | MC[1] | MR[0] | MR[1] | slug_magenta | flash_RM);
	assign Red[1] = ActR & (border | MC[0] | MC[2] | MR[0] | MR[2] | slug_magenta | flash_RM);
	assign Red[0] = ActR & (border | MC[0] | MC[1] | MC[2] | MC[3] | MR[0] | MR[1] | MR[2] | MR[3] | slug_magenta | flash_RM);
	assign Green[2] = ActR & (border | MG[0] | MG[1] | flash_GM);
	assign Green[1] = ActR & (border | MG[0] | MG[2] | flash_GM);
	assign Green[0] = ActR & (border | MG[0] | MG[1] | MG[2] | MG[3] | flash_GM);
	assign Blue[1] = ActR & (slug | slug_magenta | flash_blue);
	assign Blue[0] = ActR & (slug |slug_magenta | flash_blue);



endmodule