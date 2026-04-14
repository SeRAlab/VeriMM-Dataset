module top_module(
    input clk,
    input rst,
    input [2:0] reg_src,
    input [2:0] reg_dst,
    input [2:0] reg_wrt_dst,
    input reg_wrt,
    input [7:0] wrt_data,
    output reg [7:0] reg_src_dat,
    output reg [7:0] reg_dst_dat
);reg [7:0] reg_mem [7:0];

    always @(posedge clk) begin
        if (reg_wrt == 1)
            reg_mem[reg_wrt_dst] = wrt_data;
        reg_src_dat = reg_mem[reg_src];
        reg_dst_dat = reg_mem[reg_dst];
    end
    
    always @(rst) begin
        if (rst == 1) begin
            reg_mem[0]  = 8'b00000000;
            reg_mem[1]  = 8'b00000001;
            reg_mem[2]  = 8'b00000010;
            reg_mem[3]  = 8'b00000011;
            reg_mem[4]  = 8'b00000100;
            reg_mem[5]  = 8'b00000101;
            reg_mem[6]  = 8'b00000110;
            reg_mem[7]  = 8'b00000111;
        end
    end
    
endmodule