module top_module(
    input A,
    output Z,
    input TE,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);reg Z_reg;

    always @(*) begin
        if (VGND >= VPWR) begin
            Z_reg = ~A;
        end else if (TE == 1) begin
            Z_reg = ~A;
        end else begin
            Z_reg = A;
        end
    end

    assign Z = Z_reg;

endmodule