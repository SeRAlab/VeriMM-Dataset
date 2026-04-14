module top_module(
	input wire clk,
	input wire reset,
	input wire [3:0] alu_op,
	input wire [31:0] alu_in_0,
	input wire [31:0] alu_in_1,
	input wire br_flag,
	input wire [1:0] mem_op,
	input wire [31:0] mem_wr_data,
	input wire [2:0] ctrl_op,
	input wire [4:0] dst_addr,
	input wire gpr_we_,
	input wire [3:0] exp_code,
	input wire stall,
	input wire flush,
	input wire [31:0] if_pc,
	input wire if_en,
	output reg [31:0] id_pc,
	output reg id_en,
	output reg [3:0] id_alu_op,
	output reg [31:0] id_alu_in_0,
	output reg [31:0] id_alu_in_1,
	output reg id_br_flag,
	output reg [1:0] id_mem_op,
	output reg [31:0] id_mem_wr_data,
	output reg [2:0] id_ctrl_op,
	output reg [4:0] id_dst_addr,
	output reg id_gpr_we_,
	output reg [3:0] id_exp_code
);always @(posedge clk or posedge reset) begin
		if (reset) begin
			id_pc <= 32'h00000000;
			id_en <= 1'b0;
			id_alu_op <= 4'b0000;
			id_alu_in_0 <= 32'h00000000;
			id_alu_in_1 <= 32'h00000000;
			id_br_flag <= 1'b0;
			id_mem_op <= 2'b00;
			id_mem_wr_data <= 32'h00000000;
			id_ctrl_op <= 3'b000;
			id_dst_addr <= 5'b00000;
			id_gpr_we_ <= 1'b0;
			id_exp_code <= 4'b0000;
		end else begin
			if (stall) begin
				// do nothing
			end else if (flush) begin
				id_pc <= 32'h00000000;
				id_en <= 1'b0;
				id_alu_op <= 4'b0000;
				id_alu_in_0 <= 32'h00000000;
				id_alu_in_1 <= 32'h00000000;
				id_br_flag <= 1'b0;
				id_mem_op <= 2'b00;
				id_mem_wr_data <= 32'h00000000;
				id_ctrl_op <= 3'b000;
				id_dst_addr <= 5'b00000;
				id_gpr_we_ <= 1'b0;
				id_exp_code <= 4'b0000;
			end else begin
				id_pc <= if_pc;
				id_en <= if_en;
				id_alu_op <= alu_op;
				id_alu_in_0 <= alu_in_0;
				id_alu_in_1 <= alu_in_1;
				id_br_flag <= br_flag;
				id_mem_op <= mem_op;
				id_mem_wr_data <= mem_wr_data;
				id_ctrl_op <= ctrl_op;
				id_dst_addr <= dst_addr;
				id_gpr_we_ <= gpr_we_;
				id_exp_code <= exp_code;
			end
		end
	end

endmodule