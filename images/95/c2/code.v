module alu_16bit(
    input [15:0] a,
    input [15:0] b,
    input [2:0] ctrl,
    output reg [15:0] result
);

always @(*)
    case (ctrl)
        3'b000: result = a + b;    // Addition
        3'b001: result = a - b;    // Subtraction
        3'b010: result = a & b;    // AND
        3'b011: result = a | b;    // OR
        3'b100: result = a ^ b;    // XOR
        default: result = 16'b0;   // Default case
    endcase

endmodule