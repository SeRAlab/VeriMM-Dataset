module top_module(a, b, sel, c);input[15:0] a, b;
	input[3:0] sel;
	
	output[15:0] c;
	
	reg[15:0] c;
	
	parameter alupass = 0,
				 andOp   = 1,
				 orOp    = 2,
				 notOp   = 3,
				 xorOp   = 4,
				 plus    = 5,
				 alusub  = 6,
				 inc     = 7,
				 dec     = 8,
				 zero    = 9;
				 
	always @(a or b or sel) begin
		case (sel)
			alupass : c <= a ; 
			andOp   : c <= a & b ; 
			orOp    : c <= a | b ; 
         notOp   : c <= a ^ b ; 
         xorOp   : c <= ~a ; 
         plus    : c <= a + b ; 
         alusub  : c <= a - b ; 
         inc     : c <= a + 1 ; 
         dec     : c <= a - 1 ; 
         zero    : c <= 0 ; 
		 default : c <= 0;
		endcase 	
	end
	
endmodule