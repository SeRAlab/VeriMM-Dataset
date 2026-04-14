module alu (
    input [15:0] A,
    input [15:0] B,
    input opcode,
    output reg [15:0] result
);
    always @(*) begin
        case (opcode)
            1'b0: result = A + B; // Addition
            1'b1: result = A - B; // Subtraction
            default: result = 16'b0; // Default case (not used)
        endcase
    end
endmodule