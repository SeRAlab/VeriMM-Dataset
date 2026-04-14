module ALU_16bit(  
    input [15:0] A,  
    input [15:0] B,  
    input [2:0] opcode,  
    output reg [15:0] result,  
    output reg cmp_result  
);  
    always @(*) begin  
        case (opcode)  
            3'b000: result = A + B; // Addition  
            3'b001: result = A - B; // Subtraction  
            3'b010: result = A & B; // Bitwise AND  
            3'b011: result = A | B; // Bitwise OR  
            3'b100: result = A ^ B; // Bitwise XOR  
            3'b101: begin // Comparison  
                cmp_result = (A < B) ? 1'b1 : 1'b0;  
                result = 16'b0; // No meaningful result for comparison  
            end  
            3'b110: result = A << 1; // Logical Shift Left  
            3'b111: result = A >> 1; // Logical Shift Right  
            default: result = 16'b0;  
        endcase  
    end  
endmodule