module top_module(output reg [1:0] Z, input [1:0] op, input [1:0] A, B);// Implement the AND operation
    always @(*) begin
        case(op)
            2'b00: Z = A & B;      // AND
            2'b01: Z = A | B;      // OR
            2'b10: Z = A + B;      // ADD
            2'b11: Z = A - B;      // SUBTRACT
            default: Z = 2'b0;
        endcase
    end

endmodule