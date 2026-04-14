module ALU (
    input [7:0] A,
    input [7:0] B,
    input [2:0] Op,
    output reg [7:0] Result
);
    always @(*) begin
        case (Op)
            3'b000: Result = A + B;       // ADD
            3'b001: Result = A - B;       // SUBTRACT
            3'b010: Result = A & B;       // AND
            3'b011: Result = A | B;       // OR
            3'b100: Result = ~A;          // NOT
            default: Result = 8'b00000000; // Default case
        endcase
    end
endmodule