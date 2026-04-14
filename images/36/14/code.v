module ALU (  
    input [31:0] A,  
    input [31:0] B,  
    input [3:0] opcode,  
    output reg [31:0] result,  
    output reg zero  
);  
    always @(*) begin  
        case (opcode)  
            4'b0000: result = A + B; // Addition  
            4'b0001: result = A - B; // Subtraction  
            4'b0010: result = A & B; // Bitwise AND  
            4'b0011: result = A | B; // Bitwise OR  
            4'b0100: result = A ^ B; // Bitwise XOR  
            4'b0101: result = A << 1; // Logical Shift Left  
            4'b0110: result = A >> 1; // Logical Shift Right  
            4'b0111: result = (A < B) ? 32'b1 : 32'b0; // Set on Less Than  
            default: result = 32'b0; // Default case  
        endcase  
        zero = (result == 32'b0);  
    end  
endmodule