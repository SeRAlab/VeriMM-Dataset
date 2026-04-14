module top_module(selector, salida);input [1:0] selector;
	output reg [2:0] salida=0;
		
		always @(selector)
			begin
				case(selector)
					0: salida=3'b010;
					1: salida=3'b100;
					2: salida=3'b101;
					3: salida=3'b110;
				endcase
			end
endmodule