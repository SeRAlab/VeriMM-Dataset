module ALU_32bit (
    input [31:0] A,         // First 32-bit input
    input [31:0] B,         // Second 32-bit input
    input [2:0] ALU_op,     // 3-bit operation selector
    output reg [31:0] result // 32-bit output result
);
    
    always @(*) begin
        case(ALU_op)
            3'b000: result = A + B;     // Addition
            3'b001: result = A - B;     // Subtraction
            3'b010: result = A & B;     // AND
            3'b011: result = A | B;     // OR
            3'b100: result = A ^ B;     // XOR
            default: result = 32'b0;     // Default case
        endcase
    end
endmodule