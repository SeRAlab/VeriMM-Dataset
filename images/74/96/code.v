module priority_encoder (
	input [3:0] d,
	output reg [1:0] y);

	always @(*) begin
		casez (d)
			4'b1000: y = 2'b11;
			4'b0100: y = 2'b10;
			4'b0010: y = 2'b01;
			4'b0001: y = 2'b00;
			default: y = 2'b00;
		endcase
	end
	
endmodule