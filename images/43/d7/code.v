module top_module(Leds,HexVal);output[0:6] Leds;
	input [3:0] HexVal;
	reg   [0:6] Leds;

	always @(HexVal) begin
		case(HexVal)
			4'h0:  Leds = 7'b000_0001;  	
			4'h1:  Leds = 7'b100_1111;  	
			4'h2:  Leds = 7'b001_0010;  	
			4'h3:  Leds = 7'b000_0110;  	
			4'h4:  Leds = 7'b100_1100;  	
			4'h5:  Leds = 7'b010_0100;  	
			4'h6:  Leds = 7'b010_0000;  	
			4'h7:  Leds = 7'b000_1111;  	
			4'h8:  Leds = 7'b000_0000;  	
			4'h9:  Leds = 7'b000_0100;  	
			4'hA:  Leds = 7'b000_1000;  	
			4'hB:  Leds = 7'b110_0000;  	
			4'hC:  Leds = 7'b011_0001;  	
			4'hD:  Leds = 7'b100_0010;  	
			4'hE:  Leds = 7'b011_0000;  	
			4'hF:  Leds = 7'b011_1000;  	
			default:  Leds = 7'b111_1111; 
		endcase
	end
endmodule