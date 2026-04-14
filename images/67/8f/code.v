module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    input VPWR,
    input VGND,
    output reg X
);always @*
    begin
        case ({A1, A2})
            2'b00: X = 1'b0;
            2'b01: X = 1'b1;
            2'b10: X = 1'b1;
            2'b11: X = 1'b0;
            default: X = 1'bx;
        endcase
        
        if (B1) X = 1'b1;
        if (C1) X = 1'b0;
        if (D1) X = 1'b1;
        if (VPWR) X = 1'b1;
        if (VGND) X = 1'b0;
    end

endmodule