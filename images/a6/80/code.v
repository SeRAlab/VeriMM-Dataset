module shift_register (
	input clk,
	input si,
	output reg [3:0] po);always @(posedge clk) begin
	po <= {po[2:0], si};
end

endmodule