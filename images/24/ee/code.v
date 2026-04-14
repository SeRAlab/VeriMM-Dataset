module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [2:0] op_sel,
    output reg [63:0] result,
    output reg zero
);
    always @(*) begin
        case(op_sel)
            3'b000: result = A + B;          // Addition
            3'b001: result = A - B;          // Subtraction
            3'b010: result = A & B;          // Bitwise AND
            3'b011: result = A | B;          // Bitwise OR
            3'b100: result = A ^ B;          // Bitwise XOR
            default: result = 64'b0;
        endcase
        zero = (result == 64'b0);
    end
endmodule