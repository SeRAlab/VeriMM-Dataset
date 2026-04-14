module top_module(
    input shift_reg_en,
    input shift_reg_ld_reg,
    input txak,
    input [3:0] out,
    input tx_under_prev_i_reg,
    input abgc_i_reg,
    input [6:0] Tx_fifo_data,
    input SR,
    input s_axi_aclk,
    input shift_reg_ld_reg_0,
    output master_sda_reg,
    output [7:0] Q,
    output slave_sda_reg
);reg [7:0] shift_reg;

always @(posedge s_axi_aclk) begin
    if (shift_reg_en) begin
        shift_reg <= {shift_reg[6:0], shift_reg[7]};
    end
    if (shift_reg_ld_reg) begin
        shift_reg <= {shift_reg[6:0], shift_reg_ld_reg_0};
    end
end

assign Q = shift_reg;
assign master_sda_reg = ((txak & out[3] & out[0] & out[2] & Q[7] & tx_under_prev_i_reg) ? 1 : 0);

assign slave_sda_reg = ((Q[7] & out[2] & out[3] & abgc_i_reg & out[1] & txak) ? 1 : 0);

endmodule