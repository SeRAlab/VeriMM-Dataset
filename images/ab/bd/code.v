module top_module(
    input A,
    input B,
    input CI,
    output reg SUM,
    output reg COUT_N,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);always @(*) begin
    SUM = A ^ B ^ CI;
    COUT_N = (A & B) | (A & CI) | (B & CI);
end

endmodule