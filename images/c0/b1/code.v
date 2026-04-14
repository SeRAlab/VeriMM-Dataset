module N8080_RegSelect(
	input [2:0]SEL,
	input rstatus,			
	output reg [2:0]RAMSEL
	);
	always @* begin
		case(SEL)
			0: RAMSEL = 3'b000;	
			1: RAMSEL = rstatus ? 3'b010 : 3'b001;	
			2: RAMSEL = rstatus ? 3'b001 : 3'b010;	
			3: RAMSEL = 3'b011; 					
			default: RAMSEL = 3'b100;	
		endcase
	end
endmodule