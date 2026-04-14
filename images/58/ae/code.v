module top_module(
	input sys_clk,
	input alu_rst,

	input [31:0] a,
	input [31:0] b,
	input valid_i,

	output [31:0] r,
	output reg valid_o
);reg r_one;
always @(posedge sys_clk) begin
	if(alu_rst)
		valid_o <= 1'b0;
	else
		valid_o <= valid_i;
	case({a[31], b[31]})
		2'b00: r_one <= a[30:0] > b[30:0];
		2'b01: r_one <= 1'b1;
		2'b10: r_one <= 1'b0;
		2'b11: r_one <= a[30:0] < b[30:0];
	endcase
end

assign r = r_one ? 32'h3f800000: 32'h00000000;

endmodule