module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_op,
    output reg [31:0] ALU_out,
    output reg ALU_zero
);
    
    always @(*) begin
        case (ALU_op)
            4'b0000: ALU_out = A + B; // Addition
            4'b0001: ALU_out = A - B; // Subtraction
            4'b0010: ALU_out = A & B; // Bitwise AND
            4'b0011: ALU_out = A | B; // Bitwise OR
            4'b0100: ALU_out = A ^ B; // Bitwise XOR
            4'b0101: ALU_out = A << 1; // Left Shift
            4'b0110: ALU_out = A >> 1; // Right Shift
            4'b0111: ALU_out = (A < B) ? 1 : 0; // Set on Less Than
            4'b1000: ALU_out = (A < B) ? 1 : 0; // Set on Less Than Unsigned
            default: ALU_out = 32'b0; // Default case
        endcase
        ALU_zero = (ALU_out == 32'b0);
    end
endmodule