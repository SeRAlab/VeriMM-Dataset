module top_module(
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);always @(*) begin
        Y = ((A1_N & A2_N) | (B1 & B2));
    end

endmodule