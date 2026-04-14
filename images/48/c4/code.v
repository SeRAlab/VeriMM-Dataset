module shift_register_8bit (
	input clk,
	input s_in,
	input [7:0] p_in,
	input load,
	output reg [7:0] q);
always @(posedge clk) begin
	if (load) begin
		q <= p_in;
	end else begin
		q <= {q[6:0], s_in};
	end
end
endmodule