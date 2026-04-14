module top_module(
	input clk,
	input reset,

	input [31:0] rs1_to_csr,
	input CSRSel,

	output reg [31:0] csr
);always @(posedge clk) begin
	if (reset) begin
		csr <= 32'd0;
	end else begin
		if (CSRSel) begin
			csr <= rs1_to_csr;
		end
	end
end

endmodule