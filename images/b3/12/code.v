module top_module(
	input wire [7:0] a,
	input wire [7:0] b,
	input wire [1:0] op,
	input wire clk,
	input wire reset_n,
	output wire [7:0] result
);reg [7:0] temp_a;
	reg [7:0] temp_b;
	reg [7:0] temp_result;

	always @(posedge clk) begin
		if (reset_n == 0) begin
			temp_a <= 0;
			temp_b <= 0;
			temp_result <= 0;
		end
		else begin
			temp_a <= a;
			temp_b <= b;
			case (op)
				2'b00: temp_result <= temp_a + temp_b;
				2'b01: temp_result <= temp_a - temp_b;
				2'b10: temp_result <= temp_a * temp_b;
				2'b11: temp_result <= temp_a / temp_b;
			endcase
		end
	end

	assign result = temp_result;

endmodule