module top_module( input [31:0] a,
							 input [31:0] b,
							 input MemtoRegSel,
							 output [31:0] Result
							 );reg[31:0] temp;
	
	always @(*) begin 
		case (MemtoRegSel)
			0: temp <= a;
			1: temp <= b;
		endcase 
	end 
	
	assign Result = temp; 

endmodule