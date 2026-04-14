module johnson_counter (
	input clk,
	input reset,
	input enable,
	output [3:0] q
);reg [3:0] q_reg;

always @(posedge clk or posedge reset) begin
	if (reset)
		q_reg <= 4'b0000;
	else if (enable)
		q_reg <= {q_reg[2:0], ~q_reg[3]};
end

assign q = q_reg;

endmodule