module top_module(opcode,control_sel,Branch,MemRead,MemtoReg,ALUop,MemWrite,ALUSrc,RegWrite);input [6:0] opcode;
    input control_sel;  
    output reg MemRead,MemtoReg,MemWrite,RegWrite,Branch,ALUSrc;
    output reg [1:0] ALUop;
    
always@(opcode) begin
    if (control_sel)
        {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b00000000;
    else begin
        casex(opcode)
          7'b0000000: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b00000000; 
          7'b0000011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b11110000; 
          7'b0100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b10001000; 
          7'b0110011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b00100010; 
          7'b0010011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b10100011; 
          7'b1100011: {ALUSrc,MemtoReg,RegWrite,MemRead,MemWrite,Branch,ALUop} <= 8'b00000101; 
        endcase
    end
end
endmodule