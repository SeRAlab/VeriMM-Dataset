module top_module(
	input clk,
	input reset,
	output [31:0] rd1, 
	output [31:0] rd2,
	input [4:0] rs1, 
	input [4:0] rs2, 
	input [4:0] wd,
	input [31:0] w_data,
	input w_enable,
	input stall);reg [31:0] registers[31:0];

	always @ (posedge clk) begin
		if (w_enable & !stall & wd != 0)
			registers[wd] <= w_data;
	end

	
	assign rd1 = rs1 == 0 ? 32'b0 : registers[rs1];
	assign rd2 = rs2 == 0 ? 32'b0 : registers[rs2];

endmodule