module priority_encoder(
	input [7:0] data_in,
	output reg [2:0] encoded_out
);
always @(*) begin
	if (data_in[7])
		encoded_out = 3'b111;
	else if (data_in[6])
		encoded_out = 3'b110;
	else if (data_in[5])
		encoded_out = 3'b101;
	else if (data_in[4])
		encoded_out = 3'b100;
	else if (data_in[3])
		encoded_out = 3'b011;
	else if (data_in[2])
		encoded_out = 3'b010;
	else if (data_in[1])
		encoded_out = 3'b001;
	else if (data_in[0])
		encoded_out = 3'b000;
	else
		encoded_out = 3'b000;
end
endmodule