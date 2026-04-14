module ALU_64bit (
    input [63:0] A,
    input [63:0] B,
    input [1:0] control,
    output reg [63:0] result,
    output reg overflow
);
    always @(*) begin
        overflow = 1'b0; // Default overflow to false
        case (control)
            2'b00: begin // Addition
                {overflow, result} = A + B; // Capture overflow
            end
            2'b01: begin // Subtraction
                {overflow, result} = A - B; // Capture overflow
            end
            2'b10: begin // AND
                result = A & B;
            end
            2'b11: begin // OR
                result = A | B;
            end
            default: begin
                result = 64'b0; // Default case
            end
        endcase
    end
endmodule