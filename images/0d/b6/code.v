module ALU_16bit (  
    input [15:0] A,  
    input [15:0] B,  
    input [3:0] opcode,  
    output reg [15:0] result,  
    output reg zero_flag  
);  
    always @(*) begin  
        case (opcode)  
            4'b0000: result = A + B;  // Addition  
            4'b0001: result = A - B;  // Subtraction  
            4'b0010: result = A & B;  // Bitwise AND  
            4'b0011: result = A | B;  // Bitwise OR  
            4'b0100: result = A ^ B;  // Bitwise XOR  
            4'b0101: result = A << 1; // Logical Shift Left  
            4'b0110: result = A >> 1; // Logical Shift Right  
            4'b0111: result = (A < B) ? 16'b1 : 16'b0; // Set on Less Than  
            default: result = 16'b0;  // Default case  
        endcase  
        zero_flag = (result == 16'b0);  
    end  
endmodule