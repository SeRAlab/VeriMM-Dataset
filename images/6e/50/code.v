module top_module(
           input [31: 0] oldPC,
           input [15: 0] beq_imm,
           input [25: 0] JumpImm,
           input beq_zero,
           input [1: 0] PC_sel,
           input [1: 0] Jump,
           input [31: 0] rs,
           output reg [31: 0] newPC
       );always @(oldPC or beq_imm or beq_zero or PC_sel or Jump) begin
    case (PC_sel)
        2'b00:
            newPC = oldPC + 4;
        2'b01:
            if (beq_zero == 1)
                newPC = oldPC + 4 + {{14{beq_imm[15]}}, beq_imm[15: 0], 2'b00}; 
            else
                newPC = oldPC + 4;
    endcase
    if (Jump == 1) begin
        newPC = { newPC[31:28], JumpImm[25:0], 2'b00 };
    end
    else if (Jump == 2) begin
        newPC = rs;
    end

end

endmodule