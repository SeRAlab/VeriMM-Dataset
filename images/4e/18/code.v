module top_module(output reg [3:0]Z, input [1:0]op, input [3:0] A, B, C);always @(*)
    begin
        case(op)
            2'b00: Z = A + B + C;
            2'b01: Z = A - B - C;
            2'b10: Z = A & B & C;
            2'b11: Z = A | B | C;
        endcase
    end
endmodule