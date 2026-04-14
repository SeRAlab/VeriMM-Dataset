module top_module(
    HI,
    LO,
    VPWR,
    VGND,
    VPB,
    VNB,
    CLK,
    RST
);output HI;
    output LO;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;
    input CLK;
    input RST;

    reg HI;
    reg LO;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            HI <= 0;
            LO <= 0;
        end else begin
            if (VPB > VNB) begin
                HI <= 1;
                LO <= 0;
            end else if (VNB > VPB) begin
                HI <= 0;
                LO <= 1;
            end else begin
                HI <= 0;
                LO <= 0;
            end
        end
    end

endmodule