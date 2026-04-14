module four_bit_adder(
	input [3:0] A,
	input [3:0] B,
	input CLK,
	input RST,
	output reg [4:0] SUM
	);
	
	always@(posedge CLK) begin
		if (RST) begin
			SUM <= 5'b0;
		end
		else begin
			SUM <= {1'b0, A} + {1'b0, B};
		end
	end

endmodule