module alu_16(output reg [15:0] Z, input [1:0] op, input [15:0] A, B, C);

    always @(*) begin
        case (op)
            2'b00: Z = A + B;
            2'b01: Z = A - B;
            2'b10: Z = A & B;
            2'b11: Z = A | B;
        endcase
    end

endmodule