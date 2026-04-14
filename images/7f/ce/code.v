module top_module(
    clk_i,
    instr_i,
    stall_i,
    flush_i,
    PC_i,
    MemStall_i,
    IF_ID_o,
    PC_o
);input         clk_i, stall_i, flush_i, MemStall_i;
input  [31:0] instr_i, PC_i;
output [31:0] IF_ID_o, PC_o;


reg    [31:0] IF_ID_o, PC_o;

always@(posedge clk_i) begin
    if(flush_i == 1'b1) begin
        IF_ID_o <= 32'b0;
        PC_o    <= PC_i;
    end
    else if(stall_i == 1'b0 && MemStall_i == 1'b0) begin
        if(instr_i) begin
            IF_ID_o <= instr_i;
            PC_o    <= PC_i;
        end
        else begin
            IF_ID_o <= 32'b0;
            PC_o    <= 32'b0;
        end
    end
end
endmodule