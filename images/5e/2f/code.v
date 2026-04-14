module top_module(input		[31:0]	i_dat0, i_dat1, 
		 input			control,
		 output	reg	[31:0]	o_dat);always @(*) 
		if (!control)
			o_dat = i_dat0;
		else
			o_dat = i_dat1;	
  
endmodule