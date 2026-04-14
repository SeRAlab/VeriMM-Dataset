module top_module(input  clk,
			  input  rst,
			  input  trigger,
			  output out);reg 				 out_reg;

   assign out = out_reg;
   
   always @(posedge clk)
	 if (rst)
	   out_reg <= 0;
	 else if (trigger)
	   out_reg <= ~out_reg;
   
endmodule