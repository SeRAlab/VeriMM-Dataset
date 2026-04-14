module ALU_64bit(  
    input [63:0] A,  
    input [63:0] B,  
    input [2:0] opcode,  
    output reg [63:0] result,  
    output reg carry_flag  
);  
    always @(*) begin  
        carry_flag = 0;  
        case (opcode)  
            3'b000: {carry_flag, result} = A + B; // Addition  
            3'b001: {carry_flag, result} = A - B; // Subtraction  
            3'b010: result = A & B; // Bitwise AND  
            3'b011: result = A | B; // Bitwise OR  
            3'b100: result = A ^ B; // Bitwise XOR  
            3'b101: result = A << 1; // Logical Shift Left  
            3'b110: result = A >> 1; // Logical Shift Right  
            3'b111: result = (A < B) ? 64'b1 : 64'b0; // Set on Less Than  
            default: result = 64'b0;  
        endcase  
    end  
endmodule