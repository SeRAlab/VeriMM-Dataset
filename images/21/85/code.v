module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] func,
    output reg [7:0] result,
    output reg valid
);

always @(*) begin
    valid = 1; // Assume valid operation
    case (func)
        3'b000: result = A & B;         // AND
        3'b001: result = A | B;         // OR
        3'b010: result = A + B;         // ADD
        3'b011: result = A - B;         // SUBTRACT
        3'b100: result = A ^ B;         // XOR
        3'b101: result = ~A;            // NOT A
        3'b110: result = A << 1;        // SHIFT LEFT
        3'b111: result = A >> 1;        // SHIFT RIGHT
        default: valid = 0;              // Invalid operation
    endcase
end

endmodule