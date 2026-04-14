module priority_encoder(
	input [7:0] d,
	output reg [2:0] q);always @(*)
	casez (d)
		8'b1???????: q = 3'b111;
		8'b01??????: q = 3'b110;
		8'b001?????: q = 3'b101;
		8'b0001????: q = 3'b100;
		8'b00001???: q = 3'b011;
		8'b000001??: q = 3'b010;
		8'b0000001?: q = 3'b001;
		8'b00000001: q = 3'b000;
		default: q = 3'b000;
	endcase

endmodule