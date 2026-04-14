module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] SEL,
    output reg [3:0] OUT
);always @(*)
begin
    case(SEL)
        3'b000: OUT = A + B; // addition
        3'b001: OUT = A - B; // subtraction
        3'b010: OUT = A & B; // bitwise AND
        3'b011: OUT = A | B; // bitwise OR
        3'b100: OUT = A ^ B; // bitwise XOR
        3'b101: OUT = ~A;   // bitwise NOT of A
        3'b110: OUT = ~B;   // bitwise NOT of B
        default: OUT = 4'b0; // default to 0
    endcase
end

endmodule