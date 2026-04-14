module top_module( D , Q , CLK
    );parameter DataSize = 1 ; 
	 
	 input [ DataSize - 1 : 0 ] D ; 
	 input CLK ; 
	 
	 output [ DataSize - 1 : 0 ] Q ; 
	 reg [ DataSize - 1 : 0 ] Q ;
	 
	 always @( posedge CLK ) 
		begin : FlipFlop
			Q <= D ;
		end
		
endmodule