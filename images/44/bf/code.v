module top_module(clk500kHz,state,fets);input clk500kHz;
	


	
	
	input [3:0] state;


	
	
	
	output [7:0] fets;

		
	
	
	assign fets[3:0]={4{clk500kHz}} & state;
	assign fets[7:4]=(~fets[3:0]) & state; 
	
endmodule