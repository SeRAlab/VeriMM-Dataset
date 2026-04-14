module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] control,
    output reg [31:0] result
);
    always @(*) begin
        case (control)
            4'b0000: result = A + B;       // ADD
            4'b0001: result = A - B;       // SUBTRACT
            4'b0010: result = A & B;       // AND
            4'b0011: result = A | B;       // OR
            4'b0100: result = A ^ B;       // XOR
            4'b0101: result = ~A;          // NOT
            4'b0110: result = ~(A & B);    // NAND
            4'b0111: result = ~(A | B);    // NOR
            4'b1000: result = ~(A ^ B);    // XNOR
            4'b1001: result = A << 1;      // SHIFT LEFT
            4'b1010: result = A >> 1;      // SHIFT RIGHT
            4'b1011: result = $signed(A) >>> 1; // SHIFT RIGHT (arithmetic)
            4'b1100: result = A << 1;      // SHIFT LEFT (logical)
            4'b1101: result = A >> 1;      // SHIFT RIGHT (logical)
            default: result = 32'b0;        // Default case
        endcase
    end
endmodule