module sky130_fd_sc_hdll__o32ai (
    input A1, A2, A3, B1, B2, VPWR, VGND, VPB, VNB,
    output reg Y
);

always @(*)
begin
    if (A1 == 1'b0 && A2 == 1'b0 && A3 == 1'b0 && B1 == 1'b1 && B2 == 1'b1)
        Y <= 1'b1;
    else
        Y <= 1'b0;
end

endmodule