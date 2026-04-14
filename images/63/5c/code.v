module shift_register(
	input clk,
	input enable,
	input clear,
	input serial_in,
	output reg [3:0] q);always @(posedge clk or posedge clear) begin
	if (clear)
		q <= 4'b0000;
	else if (enable)
		q <= {q[2:0], serial_in};
end
endmodule