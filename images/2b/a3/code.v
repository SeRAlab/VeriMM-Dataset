module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] control,
    output reg [7:0] Z
);

always @(*) begin
    case (control)
        3'b000: Z = A + B;            // Addition
        3'b001: Z = A - B;            // Subtraction
        3'b010: Z = A & B;            // Bitwise AND
        3'b011: Z = A | B;            // Bitwise OR
        3'b100: Z = A ^ B;            // Bitwise XOR
        3'b101: Z = (A > B) ? 8'b00000001 : 8'b00000000; // Comparison
        default: Z = 8'b00000000;     // Default case
    endcase
end

endmodule