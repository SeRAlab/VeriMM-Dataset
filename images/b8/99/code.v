module top_module(
	input Ploc, 
	input Pant, 
	input Gloc, 
	input Gant,
	output Psal, 
	output Gsal
);assign Psal = Ploc&Pant; 
	assign Gsal = Gloc|(Ploc&Gant);endmodule