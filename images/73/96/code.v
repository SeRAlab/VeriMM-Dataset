module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] Cin,
    input [1:0] Sel,
    output reg [3:0] Sum,
    output reg Cout
);always @ (*) begin
        case (Sel)
            2'b00: begin // addition
                Sum = A + B + Cin;
                Cout = (A + B + Cin > 4'b1111) ? 1'b1 : 1'b0;
            end
            2'b01: begin // subtraction
                Sum = A - B - Cin;
                Cout = (A - B - Cin < 4'b0000) ? 1'b1 : 1'b0;
            end
            2'b10: begin // bitwise AND
                Sum = A & B;
                Cout = A & B & Cin;
            end
            2'b11: begin // bitwise OR
                Sum = A | B;
                Cout = A | B | Cin;
            end
            default: begin // invalid Sel value
                Sum = 4'b0000;
                Cout = 1'b0;
            end
        endcase
    end

endmodule