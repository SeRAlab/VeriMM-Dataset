module reg_8bit (
	input clk,
	input reset,
	input enable,
	input [7:0] d,
	output [7:0] q
);reg [7:0] q_reg;

always @(posedge clk or posedge reset) begin
	if (reset)
		q_reg <= 8'b00000000;
	else if (enable)
		q_reg <= d;
end

assign q = q_reg;

endmodule