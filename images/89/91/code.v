module top_module(
    input A_N,
    input B_N,
    input C,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);always @*
    begin
        if (A_N == 1'b0 && B_N == 1'b0 && C == 1'b0 && D == 1'b0)
            Y = 1'b1;
        else
            Y = 1'b0;
    end

endmodule