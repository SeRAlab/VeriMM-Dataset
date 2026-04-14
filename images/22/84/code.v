module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] ctrl,
    output reg [7:0] Y
);
    always @(*) begin
        case (ctrl)
            3'b000: Y = A + B;              // Addition
            3'b001: Y = A - B;              // Subtraction
            3'b010: Y = A & B;              // AND
            3'b011: Y = A | B;              // OR
            3'b100: Y = A ^ B;              // XOR
            3'b101: Y = ~A;                 // NOT
            3'b110: Y = A + 1;              // Increment
            3'b111: Y = A - 1;              // Decrement
            default: Y = 8'b00000000;       // Default case
        endcase
    end
endmodule