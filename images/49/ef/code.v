module top_module(input1, input2, select, out);input input1;    
	input input2;    
	input select;    
	
	output out;      
	
	assign out = ((~select) & input1) | (select & input2);endmodule