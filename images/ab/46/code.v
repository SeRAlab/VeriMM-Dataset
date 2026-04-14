module top_module(
    input [3:0] op,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] res
);always @(op or a or b)
begin
    case (op)
        4'b0000: res = a + b; // Addition
        4'b0001: res = a - b; // Subtraction
        4'b0010: res = b - a; // Reverse Subtraction
        4'b0011: res = a & b; // Bitwise AND
        4'b0100: res = a | b; // Bitwise OR
        4'b0101: res = a ^ b; // Bitwise XOR
        4'b0110: res = a << b; // Left Shift
        4'b0111: res = a >> b; // Right Shift
        4'b1000: res = $unsigned(a) >>> b; // Logical Right Shift
        4'b1001: res = b; // Move
        4'b1010: res = { 16'd0, b[15:0] }; // Zero-Extend
        4'b1011: res = a | (b << 16); // Concatenate

        4'b1100: res = (a < b) ? 1 : 0; // Less Than
        4'b1101: res = (a <= b) ? 1 : 0; // Less Than or Equal
        4'b1110: res = (a == b) ? 1 : 0; // Equal
        4'b1111: res = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx; // Don't care
    endcase
end

endmodule