module top_module(functField, controlData);input wire [5:0] functField;
	output reg [8:0] controlData;

	always @ (*) begin
		case(functField) 
		    6'b000000: controlData = 9'b100_100_010; 
		    6'b100011: controlData = 9'b011_110_000; 
		    6'b101011: controlData = 9'b010_001_000; 
		    
		    6'b000100: controlData = 9'b000_000_101; 

	 	endcase 
	end
endmodule