module top_module(
    input [31:0] A,
    input [31:0] B,
	 input [4:0] s,
    output reg [31:0] C,
    input [3:0] ALUOp
    );always @(*) begin
		case(ALUOp)
			4'b0000 : C = A + B;							
			4'b0001 : C = A - B;							
			4'b0010 : C = A & B;							
			4'b0011 : C = A | B;							
			4'b0100 : C = B << s;						
			4'b0101 : C = B >> s;						
			4'b0110 : C = $signed(B) >>> s;			
			4'b0111: C = B << A[4:0];					
			4'b1000: C = B >> A[4:0];					
			4'b1001: C = $signed(B) >>> A[4:0];		
			4'b1010: C = (A & ~B) | (~A & B);		
			4'b1011: C = ~(A | B);						
			4'b1100: C = $signed(A) < $signed(B);	
			4'b1101: C = A < B;							
			default : C = 32'h00000000;
		endcase
	end

endmodule