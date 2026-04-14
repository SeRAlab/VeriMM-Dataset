module top_module(
	 input  RegRA,               
	 input  [31:0] RegData,      
	 input  [31:0] PCplus8,      
	 output  [31:0] raRegData    
	 );assign raRegData = RegRA ? PCplus8 : RegData;endmodule