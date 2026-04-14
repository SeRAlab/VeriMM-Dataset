module top_module(input [7:0] number1OutExpo, input [7:0] number2OutExpo, input sign, output reg [7:0] ResultExponent8bits);always @ (number1OutExpo or number2OutExpo or sign)
	begin
		case (sign)
			0:
			begin
				ResultExponent8bits=number1OutExpo;
			end
			1:
			begin
				ResultExponent8bits=number2OutExpo;
			end
		endcase
	end
endmodule