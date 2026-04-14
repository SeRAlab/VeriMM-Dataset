module top_module(
		input clk, 
		input [31:0]  instr_i,
		input [31:0]  pc_i,
		output reg [31:0] pc_o,	
		output reg [31:0] instr_o
    );always @(posedge clk) begin
		instr_o=instr_i;
		pc_o=pc_i;
end
endmodule