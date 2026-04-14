module ALU_8bit (
    input [7:0] A,
    input [7:0] B,
    input [2:0] sel,
    output reg [7:0] R,
    output reg C
);
    always @(*) begin
        case (sel)
            3'b000: R = A & B; // AND
            3'b001: R = A | B; // OR
            3'b010: R = A ^ B; // XOR
            3'b011: {C, R} = A + B; // ADD
            3'b100: {C, R} = A - B; // SUB
            3'b101: R = ~(A & B); // NAND
            3'b110: R = ~(A | B); // NOR
            3'b111: R = ~(A ^ B); // XNOR
            default: R = 8'b00000000; // Default case
        endcase
    end
endmodule