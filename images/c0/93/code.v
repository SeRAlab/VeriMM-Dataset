module TrapDetect(
    input  Trap,
    input  TrapCond,
    input  [31:0] ALUResult,
    output EXC_Tr
    );
    wire ALUZero = (ALUResult == 32'h00000000);
    assign EXC_Tr = Trap & (TrapCond ^ ALUZero);
endmodule