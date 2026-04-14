module top_module(
	input wire[3:0] num,
	input wire en, dp, sign,
	output wire[7:0] hex
);reg [6:0] sseg;

	always @*
	begin
		if (~en)
			sseg <= 7'b0000000;
		else if (sign)
			sseg <= 7'b1000000;
		else
			case (num)
				4'h0: sseg <= 7'b0111111;
				4'h1: sseg <= 7'b0000110;
				4'h2: sseg <= 7'b1011011;
				4'h3: sseg <= 7'b1001111;
				4'h4: sseg <= 7'b1100110;
				4'h5: sseg <= 7'b1101101;
				4'h6: sseg <= 7'b1111101;
				4'h7: sseg <= 7'b0000111;
				4'h8: sseg <= 7'b1111111;
				4'h9: sseg <= 7'b1101111;
				4'ha: sseg <= 7'b1110111;
				4'hb: sseg <= 7'b1111100;
				4'hc: sseg <= 7'b1011000;
				4'hd: sseg <= 7'b1011110;
				4'he: sseg <= 7'b1111001;
				4'hf: sseg <= 7'b1110001;
				default: sseg <= 7'b1010011;
			endcase
	end

	assign hex = { (dp & en), sseg };
	
endmodule