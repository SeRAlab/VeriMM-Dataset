module decoder (
	input [1:0] binary_in,
	output reg [3:0] one_hot_out);always @(*) begin
		case (binary_in)
			2'b00: one_hot_out <= 4'b0001;
			2'b01: one_hot_out <= 4'b0010;
			2'b10: one_hot_out <= 4'b0100;
			2'b11: one_hot_out <= 4'b1000;
		endcase
	end
	
endmodule