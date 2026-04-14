module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] ALU_control,
    output reg [63:0] ALU_result
);
    always @(*) begin
        case (ALU_control)
            3'b000: ALU_result = A + B;           // Addition
            3'b001: ALU_result = A - B;           // Subtraction
            3'b010: ALU_result = A & B;           // AND
            3'b011: ALU_result = A | B;           // OR
            3'b100: ALU_result = A ^ B;           // XOR
            3'b101: ALU_result = ~B;               // NOT B
            3'b110: ALU_result = A << 1;          // Shift Left
            3'b111: ALU_result = A >> 1;          // Shift Right
            default: ALU_result = 64'b0;          // Default case
        endcase
    end
endmodule