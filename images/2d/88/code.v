module ALU_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    input [3:0] opcode,  
    output reg [15:0] Y  
);  
    always @(*) begin  
        case(opcode)  
            4'b0000: Y = A + B;                     // Addition  
            4'b0001: Y = A - B;                     // Subtraction  
            4'b0010: Y = A & B;                     // Bitwise AND  
            4'b0011: Y = A | B;                     // Bitwise OR  
            4'b0100: Y = A ^ B;                     // Bitwise XOR  
            4'b0101: Y = ~A;                        // Logical NOT  
            4'b0110: Y = A << 1;                    // Shift Left  
            4'b0111: Y = A >> 1;                    // Shift Right  
            default: Y = 16'b0;                     // Default case  
        endcase  
    end  
endmodule