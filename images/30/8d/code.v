module ALU_16bit (
    input [15:0] A,
    input [15:0] B,
    input [3:0] ALU_control,
    output reg [15:0] ALU_result
);
    always @(*) begin
        case (ALU_control)
            4'b0000: ALU_result = A + B;             // Addition
            4'b0001: ALU_result = A - B;             // Subtraction
            4'b0010: ALU_result = A & B;             // Bitwise AND
            4'b0011: ALU_result = A | B;             // Bitwise OR
            4'b0100: ALU_result = A ^ B;             // Bitwise XOR
            4'b0101: ALU_result = A << 1;            // Logical Shift Left
            4'b0110: ALU_result = A >> 1;            // Logical Shift Right
            4'b0111: ALU_result = (A < B) ? 16'b1 : 16'b0; // Comparison
            default: ALU_result = 16'b0000000000000000; // Default case
        endcase
    end
endmodule