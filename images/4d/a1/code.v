module top_module(sw,led);input [2:0] sw;
	output [7:0] led;
	
	reg [7:0] led;
	always @(sw)
		begin
			case(sw)
				3'b000: led=8'b0111_1111;
				3'b001: led=8'b1011_1111;
				3'b010: led=8'b1101_1111;
				3'b011: led=8'b1110_1111;
				3'b100: led=8'b1111_0111;
				3'b101: led=8'b1111_1011;
				3'b110: led=8'b1111_1101;
				3'b111: led=8'b1111_1110;
				default: led=8'b0000_0000;
			endcase
		end
endmodule