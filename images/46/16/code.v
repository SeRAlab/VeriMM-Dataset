module top_module(
    Y,
    VOUT,
    VREF,
    A1,
    A2,
    B1,
    B2,
    VPWR,
    VGND,
    VPB,
    VNB
);output reg [1:0] Y;
    output reg VOUT;
    output reg VREF;
    input A1;
    input A2;
    input B1;
    input B2;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    always @* begin
        case ({A1, A2, B1, B2})
            4'b0000: Y = 2'b00;
            4'b0001: Y = 2'b01;
            4'b0010: Y = 2'b10;
            4'b0011: Y = 2'b11;
            4'b0100: Y = 2'b00;
            4'b0101: Y = 2'b01;
            4'b0110: Y = 2'b10;
            4'b0111: Y = 2'b11;
            4'b1000: Y = 2'b00;
            4'b1001: Y = 2'b01;
            4'b1010: Y = 2'b10;
            4'b1011: Y = 2'b11;
            4'b1100: Y = 2'b00;
            4'b1101: Y = 2'b01;
            4'b1110: Y = 2'b10;
            4'b1111: Y = 2'b11;
        endcase
    end

    always @* begin
        if (Y % 2 == 0)
            VOUT = VPWR;
        else
            VOUT = VGND;
    end

    always @* begin
        if (Y < 2)
            VREF = VPB;
        else
            VREF = VNB;
    end

endmodule