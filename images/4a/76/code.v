module top_module(
input wire [7:0] key_code,
output reg [7:0] ascii_code
);always@*
begin

	case(key_code)
		8'h05: ascii_code = 8'h21;
		8'h06: ascii_code = 8'h22;
		8'h1c: ascii_code = 8'h41;
		8'h23: ascii_code = 8'h44;
		8'h2b: ascii_code = 8'h46;
		8'h33: ascii_code = 8'h48;
		8'h3a: ascii_code = 8'h4d;
		8'h2d: ascii_code = 8'h52;
		8'h1b: ascii_code = 8'h53;
		8'h2c: ascii_code = 8'h54;
		8'h72: ascii_code = 8'h35;
		8'h6b: ascii_code = 8'h34;
		8'h74: ascii_code = 8'h36;
		8'h75: ascii_code = 8'h38;
		8'h5a: ascii_code = 8'h0d;
		default ascii_code = 8'b0;
	endcase
end


endmodule