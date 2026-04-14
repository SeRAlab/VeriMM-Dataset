module top_module(
    input A1,
    input A2,
    input B1,
    input VPWR,
    input VGND,
    output reg X
);always @(*)
begin
    case ({A1, A2, B1, VPWR, VGND})
        5'b00000: X = 1'b0;
        5'b00001: X = 1'b0;
        5'b00100: X = 1'b0;
        5'b00101: X = 1'b0;
        5'b01000: X = 1'b0;
        5'b01001: X = 1'b0;
        5'b01100: X = 1'b0;
        5'b01101: X = 1'b0;
        5'b10010: X = 1'b1;
        5'b10001: X = 1'b0;
        5'b10110: X = 1'b1;
        5'b10111: X = 1'b0;
        5'b11010: X = 1'b1;
        5'b11001: X = 1'b0;
        5'b11110: X = 1'b1;
        5'b11111: X = 1'b0;
        default: X = 1'bx;
    endcase
end

endmodule