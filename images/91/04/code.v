module top_module(opcode, control_sel, MemRead, MemtoReg, MemWrite, RegWrite, Branch, ALUSrc, ALUop);input [6:0] opcode;
    input control_sel;
    output reg MemRead, MemtoReg, MemWrite, RegWrite, Branch, ALUSrc;
    output reg[1:0] ALUop;
    
    
    always@(opcode, control_sel) begin
        casex({control_sel, opcode})
            8'b00110011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00100010;
            
            8'b00000011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b11110000;
            8'b00100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b10001000;
            8'b01100011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00000101;
            8'b00010011: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b10100010;
            default: {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUop} <= 8'b00000000;
        endcase
    end
    
endmodule