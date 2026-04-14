module ALU (
    input [15:0] A,
    input [15:0] B,
    input [3:0] control,
    output reg [15:0] result,
    output reg Z
);
    always @(*) begin
        case (control[1:0])
            2'b00: result = A + B;          // Addition
            2'b01: result = A - B;          // Subtraction
            2'b10: result = A & B;          // Bitwise AND
            2'b11: result = A | B;          // Bitwise OR
            default: result = 16'b0000000000000000;
        endcase
        Z = (result == 16'b0000000000000000) ? 1'b1 : 1'b0; // Zero flag
    end
endmodule