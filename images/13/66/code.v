module ALU (  
    input [31:0] A,  
    input [31:0] B,  
    input [3:0] opcode,  
    output reg [31:0] result,  
    output reg ZF  
);  
    always @(*) begin  
        case (opcode)  
            4'b0000: result = A + B;  
            4'b0001: result = A - B;  
            4'b0010: result = A & B;  
            4'b0011: result = A | B;  
            4'b0100: result = A ^ B;  
            4'b0101: result = ~(A | B);  
            4'b0110: result = ~(A & B);  
            4'b0111: result = ~(A ^ B);  
            default: result = 32'b0;  
        endcase  
        ZF = (result == 32'b0);  
    end  
endmodule