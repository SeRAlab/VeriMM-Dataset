module top_module( output [15:0] Y,
	  output [15:0] flags,
	  input [15:0] A,
	  input [15:0] B,
	  input [3:0] sel
    );reg [15:0] outreg;
	 reg [15:0] flagreg;
	 
	 reg carry;
	 reg overflow;
	 
	 always @(A, B, sel) begin
		
		flagreg = 0;
		carry = 0;
		overflow = 0;
		
		case(sel)
			4'b0011: begin						
							outreg = A ^ B;
						end
			4'b0001: begin						
							outreg = A & B;
						end
			4'b0010: begin						
							outreg = A | B;
						end
			4'b0101: begin						
							{carry, outreg} = A + B;
							overflow = (($signed(A) >= 0 && $signed(B) >= 0 && $signed(outreg) < 0) || ($signed(A) < 0 && $signed(B) < 0 && $signed(outreg) >= 0)) ? 1'b1 : 1'b0;
						end
			4'b1001, 
			4'b1011:	begin						
							{carry, outreg} = A + ~B + 1'b1;
							overflow = (($signed(A) >= 0 && $signed(B) < 0 && $signed(outreg) < 0) || ($signed(A) < 0 && $signed(B) >= 0 && $signed(outreg) >= 0)) ? 1'b1 : 1'b0;
						end
			4'b1101: begin						
							outreg = B;
						end
			4'b1111: begin						
							outreg = { B[7:0], {(8){1'b0}} };
						end
						
			default: begin 
							outreg = A;			
							flagreg = 0;
						end
			
		endcase
					
		flagreg[0] = carry;	
		flagreg[2] = (A < B) && (sel == 4'b1011);	
		flagreg[5] = overflow; 
		flagreg[6] = (outreg == 16'b0) && (sel == 4'b1011); 
		flagreg[7] = outreg[15] && (sel == 4'b1011); 
		
		if(sel == 4'b1011) begin
			outreg = A;
		end
		
	 end
	 
	 assign Y = outreg;
	 assign flags = flagreg;
		
endmodule