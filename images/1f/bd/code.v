module ALU (
    input [15:0] A,
    input [15:0] B,
    input [3:0] control,
    output reg [15:0] R,
    output reg flag
);

always @(*) begin
    case(control)
        4'b0000: R = A + B;             // ADD
        4'b0001: R = A - B;             // SUBTRACT
        4'b0010: R = A & B;             // AND
        4'b0011: R = A | B;             // OR
        4'b0100: R = A ^ B;             // XOR
        4'b0101: R = ~A;                // NOT
        4'b0110: R = A << 1;            // SHIFT LEFT
        4'b0111: R = A >> 1;            // SHIFT RIGHT
        4'b1000: R = (A < B) ? 16'b1 : 16'b0; // LESS THAN
        4'b1001: R = (A > B) ? 16'b1 : 16'b0; // GREATER THAN
        4'b1010: R = (A == B) ? 16'b1 : 16'b0; // EQUAL
        default: R = 16'b0;             // Default case
    endcase
    flag = (R != 0) ? 1 : 0;
end

endmodule