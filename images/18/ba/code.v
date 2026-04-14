module ALU (
    input [15:0] A,
    input [15:0] B,
    input [2:0] control,
    output reg [15:0] result,
    output reg overflow
);
    always @(*) begin
        overflow = 0; // Default no overflow
        case (control)
            3'b000: begin // ADD
                {overflow, result} = A + B;
            end
            3'b001: begin // SUB
                {overflow, result} = A - B;
            end
            3'b010: begin // AND
                result = A & B;
            end
            3'b011: begin // OR
                result = A | B;
            end
            3'b100: begin // XOR
                result = A ^ B;
            end
            default: result = 16'h0000; // Default case
        endcase
    end
endmodule