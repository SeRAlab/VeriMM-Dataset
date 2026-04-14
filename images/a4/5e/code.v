module priority_encoder(IN,OUT);
input [3:0] IN;
output [1:0] OUT;
reg [1:0] OUT;

always@(IN) begin
	if (IN[3])
		OUT = 2'b11;
	else if (IN[2])
		OUT = 2'b10;
	else if (IN[1])
		OUT = 2'b01;
	else if (IN[0])
		OUT = 2'b00;
	else
		OUT = 2'b00;
end

endmodule