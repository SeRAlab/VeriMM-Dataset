module top_module(
    input clk, rst, M_flush, M_stall, WB_stall, M_regwrite, M_memtoreg, 
    input [31:0] M_alu_out, M_readdata,
    input [4:0] M_rt_rd,
    output reg WB_regwrite,
    output reg WB_memtoreg,
    output reg [31:0] WB_readdata,
    output reg [31:0] WB_alu_out,
    output reg [4:0] WB_rt_rd
);always @(posedge clk) begin
        if (rst) begin
            WB_regwrite <= 0;
            WB_memtoreg <= 0;
            WB_readdata <= 0;
            WB_alu_out <= 0;
            WB_rt_rd <= 0;
        end else if (WB_stall) begin
            // Do nothing
        end else begin
            WB_regwrite <= M_flush ? 0 : M_regwrite;
            WB_memtoreg <= M_memtoreg;
            WB_alu_out <= M_alu_out;
            WB_readdata <= M_readdata;
            WB_rt_rd <= M_rt_rd;
        end
    end

endmodule