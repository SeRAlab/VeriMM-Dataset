module ALU (
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    output reg [7:0] result,
    output reg carry_out
);
    
    always @(*) begin
        case (op)
            2'b00: begin // Addition
                {carry_out, result} = a + b;
            end
            2'b01: begin // Subtraction
                {carry_out, result} = a - b;
            end
            2'b10: begin // AND
                result = a & b;
                carry_out = 0; // No carry for AND
            end
            2'b11: begin // OR
                result = a | b;
                carry_out = 0; // No carry for OR
            end
            default: begin
                result = 8'b00000000;
                carry_out = 0;
            end
        endcase
    end
endmodule