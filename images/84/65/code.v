module decoder (
	input [2:0] address,
	output reg [7:0] data_out);always @(*) begin
		data_out <= 8'b00000001 << address;
	end
	
endmodule