module top_module(
    Imm, nPC_sel, Zero, PC, JumpAddr, BusA,
    NPC
);input [31:0] Imm;
    input [2:0] nPC_sel;
    input Zero;
    input [31:0] PC, BusA;
    input [25:0] JumpAddr;
    output reg [31:0] NPC; 

always @(*) begin
    if (nPC_sel == 3'b001 && Zero == 1)
        
        NPC = PC + 1 + Imm;
    else if (nPC_sel == 3'b010 && Zero == 0)
        NPC = PC + 1 + Imm;
    else if (nPC_sel == 3'b011) 
        NPC = JumpAddr;
    else if (nPC_sel == 3'b100) 
        NPC = JumpAddr;
    else if (nPC_sel == 3'b101) 
        NPC = BusA;
    else if (nPC_sel == 3'b110)
        NPC = PC;
    else
        NPC = PC + 1;
end

endmodule