module priority_encoder(IN,OUT);
input [3:0] IN;
output reg [1:0] OUT;

always @(*) begin
	casez (IN)
		4'b1???: OUT = 2'b11;
		4'b01??: OUT = 2'b10;
		4'b001?: OUT = 2'b01;
		4'b0001: OUT = 2'b00;
		default: OUT = 2'b00;
	endcase
end

endmodule