module ALU_32bit (  
    input [31:0] A,  
    input [31:0] B,  
    input [1:0] OpSel,  
    output reg [31:0] Result  
);  
    always @(*) begin  
        case (OpSel)  
            2'b00: Result = A + B;          // Addition  
            2'b01: Result = A - B;          // Subtraction  
            2'b10: Result = A & B;          // Bitwise AND  
            2'b11: Result = A | B;          // Bitwise OR  
            default: Result = 32'b0;        // Default case  
        endcase  
    end  
endmodule