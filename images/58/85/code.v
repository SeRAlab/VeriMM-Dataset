module top_module(
    input A1,
    input A2,
    input A3,
    input A4,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);always @(*)
    begin
        case ({A1, A2, A3, A4, B1})
            5'b00000, 5'b00001, 5'b00100, 5'b00101, 5'b01000, 5'b01001, 5'b01100, 5'b01101, 5'b10000, 5'b10001, 5'b10100, 5'b10101, 5'b11000, 5'b11001, 5'b11100, 5'b11101:
                Y = 1'b0;
            5'b00010, 5'b00011, 5'b00110, 5'b00111, 5'b01010, 5'b01011, 5'b01110, 5'b01111, 5'b10010, 5'b10011, 5'b10110, 5'b10111, 5'b11010, 5'b11011, 5'b11110, 5'b11111:
                Y = 1'b1;
            default:
                Y = 1'bx;
        endcase
    end

endmodule