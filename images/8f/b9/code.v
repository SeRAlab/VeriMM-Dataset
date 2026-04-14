module top_module(S,U,V,W,X,Y,M,O);input[2:0] S,U,V,W,X,Y,O;
	output[23:0] M;
	
	

	reg[23:0]OUT;

	
	always@(S,U,V,W,X,Y)
		case(S)			  
			3'b000 : OUT = {O,O,O,U,V,W,X,Y}; 
			3'b001 : OUT = {O,O,U,V,W,X,Y,O}; 
			3'b010 : OUT = {O,U,V,W,X,Y,O,O}; 
			3'b011 : OUT = {U,V,W,X,Y,O,O,O};
			3'b100 : OUT = {V,W,X,Y,O,O,O,U};
			3'b101 : OUT = {W,X,Y,O,O,O,U,V};
			3'b110 : OUT = {X,Y,O,O,O,U,V,W};
			3'b111 : OUT = {Y,O,O,O,U,V,W,X};
			
	endcase	
	
	assign M = OUT;endmodule