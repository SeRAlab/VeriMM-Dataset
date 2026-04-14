module decoder_3to8(A,EN,Y);
input [2:0] A;
input EN;
output reg [7:0] Y;

always @(*) begin
	if (!EN)
		Y = 8'b00000000;
	else
		Y = 8'b00000001 << A;
end

endmodule