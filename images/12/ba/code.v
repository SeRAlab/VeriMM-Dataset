module alu(
    input [15:0] a,
    input [15:0] b,
    input [1:0] ctrl,
    output reg [15:0] result
);
    always @(*) begin
        case (ctrl)
            2'b00: result = a + b;      // Addition
            2'b01: result = a - b;      // Subtraction
            2'b10: result = a & b;      // Bitwise AND
            default: result = 16'b0;     // Default case
        endcase
    end
endmodule