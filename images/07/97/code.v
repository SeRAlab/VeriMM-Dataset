module ALU(  
    input [31:0] A,  
    input [31:0] B,  
    input [2:0] ALU_control,  
    output reg [31:0] ALU_result  
);  
    always @(*) begin  
        case (ALU_control)  
            3'b000: ALU_result = A + B;                // Addition  
            3'b001: ALU_result = A - B;                // Subtraction  
            3'b010: ALU_result = A & B;                // Bitwise AND  
            3'b011: ALU_result = A | B;                // Bitwise OR  
            3'b100: ALU_result = A ^ B;                // Bitwise XOR  
            3'b101: ALU_result = A << 1;               // Logical Shift Left  
            3'b110: ALU_result = A >> 1;               // Logical Shift Right  
            3'b111: ALU_result = (A < B) ? 32'b1 : 32'b0;  // Set on Less Than  
            default: ALU_result = 32'b0;  
        endcase  
    end  
endmodule