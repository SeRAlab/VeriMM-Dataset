module top_module( input [5:0] func,				
					input [1:0] aluop,			
					output reg[ 2:0] alucn);always@*begin
	
	case(aluop)									
		2'b00: alucn = 3'b010;				
		2'b01: alucn = 3'b110;				
		default: 								
			case(func)
				6'b100000: alucn = 3'b010; 
				6'b100010: alucn = 3'b110; 
				6'b100100: alucn = 3'b000;	
				6'b100101: alucn = 3'b001; 
				6'b101010: alucn = 3'b111; 
				default: alucn = 3'bxxx;	
			endcase
	endcase
	
end

endmodule