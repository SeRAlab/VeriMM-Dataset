module top_module( clock, reset, count );input clock;
	input reset;
	output [2:0] count; 
	reg [2:0] count; 
	 
	always @(posedge clock or  posedge reset) 
	begin 
		if  (reset) 
			count = 0;   
		else if  ( count < 3'b111 )  
			count = count + 1;   
		else 
			count = 0;   
	end 
endmodule