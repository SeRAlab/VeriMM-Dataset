module top_module(
    input A1,
    input A2,
    input B1,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);always @*
    begin
        Y = (A1 & A2 & B1) | (VPWR & VGND & VPB & VNB);
    end

endmodule