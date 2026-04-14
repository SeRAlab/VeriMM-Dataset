module top_module(
    input clk, 
    input [4:0] data_in,
    output [4:0] L
	);wire A,B,C,D,E;
	assign {E,D,C,B,A} = data_in;
	
	
	
	
	wire L40, L31, L22, L13, L04; 
	assign L40 = A & B & C & D;                        
	assign L04 = ~A & ~B & ~C & ~D; 	               
	assign L13 = ((A^B) & ~C & ~D) | 
	             (~A & ~B & (C^D));                    
	assign L31 = ((A^B) & C & D) | (A & B & (C^D));    
	assign L22 = A & B & ~C & ~D |
		         ~A & ~B & C & D |			           
		         (A^B) & (C^D);                        
	assign L = {L40, L31, L22, L13, L04}; 
endmodule