module top_module(sel, a34, a34x2, a34_n, a34x2_n, dout);input	[2:0]	sel;		
	
	input 	[33:0]	a34;		
	input	[33:0]	a34x2;		
	input	[33:0]	a34_n;		
	input	[33:0]	a34x2_n;	
	
	output	[33:0]	dout;		
	
	reg	[33:0]	dout;
	
	always@(sel or a34 or a34x2 or a34_n or a34x2_n)
	begin
	
	    case(sel)
		3'b000:	dout = 34'b0 ;
		3'b001:	dout = a34 ;
		3'b010:	dout = a34 ;
		3'b011:	dout = a34x2 ;
		3'b100:	dout = a34x2_n ;
		3'b101:	dout = a34_n ;
		3'b110:	dout = a34_n ;
		default: dout = 34'b0 ;
	    endcase  

	end

endmodule