module ALU (
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALU_control,
    output reg [31:0] Result
);

always @(*) begin
    case (ALU_control[1:0])
        2'b00: Result = A + B;        // ADD
        2'b01: Result = A - B;        // SUBTRACT
        2'b10: Result = A & B;        // AND
        2'b11: Result = A | B;        // OR
        default: Result = 32'b0;      // Default case
    endcase
end

endmodule