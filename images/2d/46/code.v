module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] SEL,
    output reg [7:0] result
);
    always @(*) begin
        case (SEL)
            3'b000: result = A + B;          // Addition
            3'b001: result = A - B;          // Subtraction
            3'b010: result = A & B;          // Bitwise AND
            3'b011: result = A | B;          // Bitwise OR
            3'b100: result = A ^ B;          // Bitwise XOR
            default: result = 8'b00000000;   // Default case
        endcase
    end
endmodule