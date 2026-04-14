module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);// Output is registered
    reg Y_reg;

    always @(*) begin
        case ({A1, A2, B1, C1, VPWR, VGND, VPB, VNB})
            8'b0xxx_xxxx: Y_reg = 1'b0;
            8'b1xxx_xxxx: Y_reg = 1'b1;
            8'bxxxx_0xxx: Y_reg = 1'b0;
            8'bxxxx_1xxx: Y_reg = 1'b1;
            8'bxxxx_x0xx: Y_reg = 1'b0;
            8'bxxxx_x1xx: Y_reg = 1'b1;
            8'bxxxx_xx0x: Y_reg = 1'b0;
            8'bxxxx_xx1x: Y_reg = 1'b1;
            8'bxxxx_xxx0: Y_reg = 1'b0;
            8'bxxxx_xxx1: Y_reg = 1'b1;
            default: Y_reg = 1'bx;
        endcase
    end

    assign Y = Y_reg;

endmodule