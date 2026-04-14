module top_module(
    rt, rd, RegDst, WriteReg
);input [4:0] rt;
    input [4:0] rd;
    input [1:0] RegDst;
    output reg[4:0] WriteReg;
    
    always @(rt or rd or RegDst)begin
        case(RegDst)
                   2'b00: WriteReg = 5'b11111;   
                   2'b01: WriteReg = rt;         
                   2'b10: WriteReg = rd;         
                   default: WriteReg = WriteReg;
        endcase       
    end
endmodule