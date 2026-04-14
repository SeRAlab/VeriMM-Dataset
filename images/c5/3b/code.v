module sky130_fd_sc_hd__fill (
    VPWR,
    VGND,
    VPB,
    VNB
);

    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    reg out;

    always @(*) begin
        if (VPB > VNB) begin
            out = VPWR;
        end else if (VPB < VNB) begin
            out = VGND;
        end else begin
            out = (VPWR + VGND) / 2;
        end
    end

endmodule