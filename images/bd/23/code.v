module top_module(
	 input  RegRA,               
	 input  [4:0] RegAddr,       
	 output  [4:0] raRegAddr    
	 );assign raRegAddr = RegRA ? 5'b11111 : RegAddr;endmodule