module ALU (
    input [31:0] A,
    input [31:0] B,
    input [2:0] ctrl,
    output reg [31:0] result,
    output reg carry_out
);
    always @(*)
    begin
        case (ctrl)
            3'b000: {carry_out, result} = A + B;          // Addition
            3'b001: {carry_out, result} = A - B;          // Subtraction
            3'b010: result = A & B;                        // Bitwise AND
            3'b011: result = A | B;                        // Bitwise OR
            3'b100: result = A ^ B;                        // Bitwise XOR
            default: result = 32'b0;                       // Default case
        endcase
    end
endmodule