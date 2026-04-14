module top_module(clk,
								result_alu_in,
								result_mem_in,
								dir_wb_in,
								sel_wb_in,
								reg_wr_in,
								result_alu_out,
								result_mem_out,
								dir_wb_out,
								sel_wb_out,
								reg_wr_out);reg [31:0] result_alu;
reg [31:0] result_mem;
reg [3:0] dir_wb;
reg sel_wb;
reg reg_wr;

input clk;
input wire [31:0] result_alu_in;
input wire [31:0] result_mem_in;
input wire [3:0] dir_wb_in;
input wire sel_wb_in;
input wire reg_wr_in;

output reg [31:0] result_alu_out;
output reg [31:0] result_mem_out;
output reg [3:0] dir_wb_out;
output reg sel_wb_out;
output reg reg_wr_out;

always @(posedge clk)
begin
    result_alu <= result_alu_in;
	 result_mem <= result_mem_in;
	 dir_wb <= dir_wb_in;
	 sel_wb<= sel_wb_in;
	 reg_wr<= reg_wr_in;
end

always @(negedge clk)
begin
    result_alu_out <= result_alu;
	 result_mem_out <= result_mem;
	 dir_wb_out <= dir_wb;
	 sel_wb_out<= sel_wb;
	 reg_wr_out<= reg_wr;
end


endmodule