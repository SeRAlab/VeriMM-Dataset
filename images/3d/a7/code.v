module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [1:0] control,
    output reg [63:0] result
);
    always @(*) begin
        case(control)
            2'b00: result = A + B;      // Addition
            2'b01: result = A - B;      // Subtraction
            2'b10: result = A & B;      // Bitwise AND
            2'b11: result = A | B;      // Bitwise OR
            default: result = 64'b0;     // Default case
        endcase
    end
endmodule