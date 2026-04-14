module top_module(
    input [31:0] E_st_data,
    input [31:0] av_ld_data_aligned_filtered,
    input clk,
    input [22:0] d_address,
    input d_read,
    input d_waitrequest,
    input d_write,
    input debugack,
    input reset_n,
    output [22:0] cpu_d_address,
    output cpu_d_read,
    output [31:0] cpu_d_readdata,
    output cpu_d_wait,
    output cpu_d_write,
    output [31:0] cpu_d_writedata,
    output dbrk_break,
    output dbrk_goto0,
    output dbrk_goto1,
    output dbrk_traceme,
    output dbrk_traceoff,
    output dbrk_traceon,
    output dbrk_trigout
);reg [31:0] dbrk_data;
    reg dbrk_break_reg, dbrk_break_pulse, dbrk_goto0_reg, dbrk_goto1_reg, dbrk_traceme_reg, dbrk_traceoff_reg, dbrk_traceon_reg, dbrk_trigout_reg;

    assign cpu_d_address = d_address;
    assign cpu_d_readdata = av_ld_data_aligned_filtered;
    assign cpu_d_read = d_read;
    assign cpu_d_writedata = E_st_data;
    assign cpu_d_write = d_write;
    assign cpu_d_wait = d_waitrequest;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            dbrk_break_reg <= 0;
            dbrk_break_pulse <= 0;
            dbrk_goto0_reg <= 0;
            dbrk_goto1_reg <= 0;
            dbrk_traceme_reg <= 0;
            dbrk_traceoff_reg <= 0;
            dbrk_traceon_reg <= 0;
            dbrk_trigout_reg <= 0;
        end else begin
            dbrk_break_pulse <= dbrk_break_reg ? ~debugack : dbrk_break_pulse;
            dbrk_break_reg <= dbrk_break_pulse;
        end
    end

    assign dbrk_data = cpu_d_write ? cpu_d_writedata : cpu_d_readdata;

    assign dbrk_goto0 = dbrk_goto0_reg;
    assign dbrk_goto1 = dbrk_goto1_reg;
    assign dbrk_traceme = dbrk_traceme_reg;
    assign dbrk_traceoff = dbrk_traceoff_reg;
    assign dbrk_traceon = dbrk_traceon_reg;
    assign dbrk_trigout = dbrk_trigout_reg;

    assign dbrk_break = dbrk_break_reg;

endmodule