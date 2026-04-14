module top_module(
    input D,
    input DE,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q,
    output Q_N,
    input CLK
);reg Q_reg;
    wire D_int;
    wire DE_int;

    assign D_int = (VPB == 1'b1) ? D : 1'bz;
    assign DE_int = (VPB == 1'b1) ? DE : 1'bz;

    always @(posedge CLK or negedge VGND)
    begin
        if (~VGND)
            Q_reg <= 1'b0;
        else if (DE_int && ~VGND)
            Q_reg <= D_int;
    end

    assign Q = (VPWR == 1'b1) ? Q_reg : 1'bz;
    assign Q_N = (VPWR == 1'b1) ? ~Q_reg : 1'bz;

endmodule