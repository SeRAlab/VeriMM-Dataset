module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ctrl,
    output reg [7:0] result,
    output reg comp
);
    always @(*) begin
        case(ctrl)
            3'b000: result = A + B;               // Addition
            3'b001: result = A - B;               // Subtraction
            3'b010: result = A & B;               // Bitwise AND
            3'b011: result = A | B;               // Bitwise OR
            3'b100: result = A ^ B;               // Bitwise XOR
            3'b101: comp = (A < B) ? 1 : 0;       // Comparison
            3'b110: result = A << 1;              // Shift Left
            3'b111: result = A >> 1;              // Shift Right
            default: result = 8'b00000000;        // Default case
        endcase
    end
endmodule