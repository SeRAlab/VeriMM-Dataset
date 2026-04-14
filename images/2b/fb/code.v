module ALU (
    input [15:0] A,
    input [15:0] B,
    input [3:0] opcode,
    output reg [15:0] result,
    output reg carry_out,
    output reg zero_flag
);

always @(*) begin
    carry_out = 0; // reset carry_out
    case (opcode)
        4'b0000: {carry_out, result} = A + B;            // Addition
        4'b0001: {carry_out, result} = A - B;            // Subtraction
        4'b0010: result = A & B;                          // AND
        4'b0011: result = A | B;                          // OR
        4'b0100: result = A ^ B;                          // XOR
        4'b0101: result = ~A;                             // NOT A
        4'b0110: result = A << 1;                         // Shift Left
        4'b0111: result = A >> 1;                         // Shift Right
        default: result = 16'b0;                          // Default case
    endcase
    zero_flag = (result == 16'b0) ? 1'b1 : 1'b0;        // Set zero flag
end
endmodule