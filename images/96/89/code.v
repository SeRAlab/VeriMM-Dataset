module top_module(OpCode, FuncCode, IFIDImmd, IFIDMemWrite, IFIDMemRead, IFIDRegWrite);input [3:0] OpCode;
    input [3:0] FuncCode;
    output wire IFIDImmd, IFIDMemWrite, IFIDMemRead;
    output wire [1:0] IFIDRegWrite;

    assign IFIDMemWrite = OpCode == 11;
    assign IFIDMemRead = OpCode == 8;

    assign IFIDImmd = (OpCode >= 4 & OpCode <= 6) |          
        (OpCode == 0 & (FuncCode >= 8 & FuncCode <= 11));

    assign IFIDRegWrite = (OpCode == 0 &           
        (FuncCode == 4 | FuncCode == 5)) ? 2 :
        (OpCode == 0 | OpCode == 8) ? 1 : 0;

endmodule