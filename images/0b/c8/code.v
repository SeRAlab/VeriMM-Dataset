module ALU(
    input [15:0] A, 
    input [15:0] B, 
    input [2:0] op, 
    output reg [15:0] result, 
    output reg zero
);
    always @(*) begin
        case (op)
            3'b000: result = A + B;          // Addition
            3'b001: result = A - B;          // Subtraction
            3'b010: result = A & B;          // Bitwise AND
            3'b011: result = A | B;          // Bitwise OR
            3'b100: result = A ^ B;          // Bitwise XOR
            default: result = 16'b0;          // Default case
        endcase
        zero = (result == 16'b0);            // Zero flag
    end
endmodule