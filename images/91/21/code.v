module top_module(
    input [15:0] D,
    input [3:0] S,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Z
);always @*
begin
    case (S)
        4'b0000: Z = D[0];
        4'b0001: Z = D[1];
        4'b0010: Z = D[2];
        4'b0011: Z = D[3];
        4'b0100: Z = D[4];
        4'b0101: Z = D[5];
        4'b0110: Z = D[6];
        4'b0111: Z = D[7];
        4'b1000: Z = D[8];
        4'b1001: Z = D[9];
        4'b1010: Z = D[10];
        4'b1011: Z = D[11];
        4'b1100: Z = D[12];
        4'b1101: Z = D[13];
        4'b1110: Z = D[14];
        4'b1111: Z = D[15];
        default: Z = 1'bx;
    endcase
end

endmodule