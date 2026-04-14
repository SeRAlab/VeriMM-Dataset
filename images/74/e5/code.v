module priority_encoder (
	input [4:0] in,
	output reg [2:0] out);

	always @(*) begin
		casez (in)
			5'b1????: out = 3'b100;
			5'b01???: out = 3'b011;
			5'b001??: out = 3'b010;
			5'b0001?: out = 3'b001;
			5'b00001: out = 3'b000;
			default: out = 3'bxxx;
		endcase
	end
	
endmodule