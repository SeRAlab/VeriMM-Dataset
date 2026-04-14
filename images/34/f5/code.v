module alu_64bit (
    input [63:0] A,
    input [63:0] B,
    input [1:0] Op,
    output reg [63:0] Result
);
    always @(*) begin
        case (Op)
            2'b00: Result = A + B;         // Addition
            2'b01: Result = A - B;         // Subtraction
            2'b10: Result = A & B;         // Bitwise AND
            default: Result = 64'b0;       // Default case
        endcase
    end
endmodule