module top_module(clk, rst_n, op, a, b, result, valid);input clk, rst_n;
input [1:0] op;
input [7:0] a, b;

output [7:0] result;
output valid;

reg [7:0] result_reg;
reg valid_reg;

always @(posedge clk) begin
	if(!rst_n) begin
		result_reg <= 8'b0;
		valid_reg <= 1'b0;
	end
	else begin
		case(op)
			2'b00: result_reg <= a + b;
			2'b01: result_reg <= a - b;
			2'b10: result_reg <= a * b;
			2'b11: result_reg <= a / b;
		endcase
		valid_reg <= 1'b1;
	end
end

assign result = result_reg;
assign valid = valid_reg;

endmodule