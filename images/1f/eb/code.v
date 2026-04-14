module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] control,
    output reg [31:0] result,
    output reg gt
);
    always @(*) begin
        case (control)
            3'b000: result = A + B;         // Addition
            3'b001: result = A - B;         // Subtraction
            3'b010: result = A & B;         // Bitwise AND
            3'b011: result = A | B;         // Bitwise OR
            3'b100: result = A ^ B;         // Bitwise XOR
            3'b101: gt = (A > B) ? 1'b1 : 1'b0; // Greater Than
            default: result = 32'b0;        // Default case
        endcase
    end
endmodule