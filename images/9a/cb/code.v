module top_module(
    input wire clk,
    input wire rst,

    input wire [31:0] p_data_i,
    output wire [31:0] p_addr_o,

    input wire seq_stop_inc_pc_i,
    input wire [31:0] jmp_pc_i,
    input wire jmp_pc_en_i,
    output wire [31:0] inst_o);assign p_addr_o = pc_ff;
assign inst_o = p_data_i;

reg [31:0] pc_ff;
always @(posedge clk) begin
    if (rst) begin
        pc_ff <= 32'h0;
    end else begin
        if (jmp_pc_en_i)
            pc_ff <= jmp_pc_i;
        else if (!seq_stop_inc_pc_i)
            pc_ff <= pc_ff + 1;
    end
end

endmodule