module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] ALU_Sel,
    output reg [63:0] Result,
    output reg Zero
);
    always @(*) begin
        case (ALU_Sel)
            3'b000: Result = A + B; // Addition
            3'b001: Result = A - B; // Subtraction
            3'b010: Result = A & B; // Bitwise AND
            3'b011: Result = A | B; // Bitwise OR
            3'b100: Result = A ^ B; // Bitwise XOR
            default: Result = 64'b0; // Default case
        endcase
        Zero = (Result == 64'b0) ? 1'b1 : 1'b0; // Set Zero flag
    end
endmodule