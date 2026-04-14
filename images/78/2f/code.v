module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] op,
    output reg [3:0] Z
);always @(*) begin
        case(op)
            3'b000: Z = A + B; // addition
            3'b001: Z = A - B; // subtraction
            3'b010: Z = A & B; // bitwise AND
            3'b011: Z = A | B; // bitwise OR
            3'b100: Z = A ^ B; // bitwise XOR
            3'b101: Z = ~A; // bitwise NOT
            default: Z = 4'bxxxx; // invalid operation
        endcase
    end

endmodule