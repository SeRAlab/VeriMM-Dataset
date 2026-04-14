module top_module(
	 input  FlushPC,           
	 input  [31:0] PCplus4,    
	 input  [31:0] nPC,        
	 output  [31:0] F_nPC      
	 );assign F_nPC = FlushPC ? nPC : PCplus4;endmodule