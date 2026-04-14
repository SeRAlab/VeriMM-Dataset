module top_module(input a, output reg [6:0] Display);reg [3:0] conta;

always @(posedge a)
begin
	conta=conta+1;
	if (conta>9)
	begin
		conta=0;
	end
	case (conta)
	4'b0000:
	begin
		Display=7'b1000000;
	end
	4'b0001:
	begin
		Display=7'b1111001;
	end
	4'b0010:
	begin
		Display=7'b0100100;
	end
	4'b0011:
	begin
		Display=7'b0110000;
	end
	4'b0100:
	begin
		Display=7'b0011001;
	end
	4'b0101:
	begin
		Display=7'b0010010;
	end
	4'b0110:
	begin
		Display=7'b0000010;
	end
	4'b0111:
	begin
		Display=7'b1111000;
	end
	4'b1000:
	begin
		Display=7'b0000000;
	end
	4'b1001:
	begin
		Display=7'b0010000;
	end
	endcase
	
end
endmodule