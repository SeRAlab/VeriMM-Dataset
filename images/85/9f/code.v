module top_module(input [31:0] inst, output reg [31:0] imm);always @(inst)
begin
    if (inst[6] == 0)
    begin
        if (inst[5] == 0)
            imm = inst[31:20];
        else
            imm = {inst[31:25],inst[11:7]};
        
    end
    else
        imm = {inst[31], inst[7], inst[30:25], inst[11:8]};
    if (imm[11])
        imm[31:12] = 20'b11111111111111111111;
end
endmodule