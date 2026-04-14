module top_module(
    w_alu_op,
    w_mem_op,
    w_jump_op,
    w_reg_jump_op,
    w_byte_op,
    w_imm_op,
    w_wdata_ctrl_out_2
);input wire w_alu_op, w_mem_op, w_byte_op, w_imm_op, w_jump_op, w_reg_jump_op;
output reg [1:0] w_wdata_ctrl_out_2;

always @(*) begin
    if(w_mem_op & ~w_imm_op & ~w_byte_op)
        w_wdata_ctrl_out_2 = 2'b00;
    else if(w_mem_op & w_byte_op)
        w_wdata_ctrl_out_2 = 2'b01;
    else if(w_mem_op & w_imm_op)
        w_wdata_ctrl_out_2 = 2'b10;
    else if((w_alu_op & ~(w_mem_op | w_byte_op | w_jump_op | w_reg_jump_op))| (w_alu_op & w_imm_op))
        w_wdata_ctrl_out_2 = 2'b11;
    else if((w_mem_op & w_imm_op))
        w_wdata_ctrl_out_2 = 2'b11;
    else if(w_jump_op & w_reg_jump_op)
        w_wdata_ctrl_out_2 = 2'b11;
    else
        w_wdata_ctrl_out_2 = 2'bXX;
end
endmodule