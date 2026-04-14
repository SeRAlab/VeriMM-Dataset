module top_module(
    input s_axi_aclk,
    input mac_addr_ram_we,
    input [0:3] mac_addr_ram_addr,
    input [3:0] gen_wr_b_gen_word_wide_mem_reg,
    output [3:0] Q,
    output [1:0] rdDestAddrNib_D_t_q_reg
);reg [127:0] memory [0:15]; // 16 MAC addresses, each with 4 bytes (32 bits)
    reg [1:0] rdDestAddrNib_D_t_q_reg_internal;
    
    always @(posedge s_axi_aclk) begin
        if (mac_addr_ram_we == 1) begin
            memory[mac_addr_ram_addr] <= {gen_wr_b_gen_word_wide_mem_reg, 8'b0}; // concatenate 8 bits of zeros
        end
        rdDestAddrNib_D_t_q_reg_internal <= memory[mac_addr_ram_addr][1:0];
    end
    
    assign Q = memory[mac_addr_ram_addr][3:0]; // only take lower 4 bits
    assign rdDestAddrNib_D_t_q_reg = rdDestAddrNib_D_t_q_reg_internal;

endmodule