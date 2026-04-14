module top_module(
    input D,
    input SLEEP_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q
);reg Q_reg;
reg D_reg;
reg SLEEP_B_reg;
reg VPWR_reg;
reg VGND_reg;
reg VPB_reg;
reg VNB_reg;

always @(posedge VPWR or negedge VGND) begin
    if (VGND == 0) begin
        Q_reg <= 1'b0;
    end else begin
        Q_reg <= D_reg;
    end
end

assign Q = Q_reg;

always @(D or SLEEP_B or VPWR or VGND or VPB or VNB) begin
    if (VGND == 0) begin
        D_reg <= 1'b0;
        SLEEP_B_reg <= 1'b0;
        VPWR_reg <= 1'b0;
        VGND_reg <= 1'b0;
        VPB_reg <= 1'b0;
        VNB_reg <= 1'b0;
    end else begin
        D_reg <= D;
        SLEEP_B_reg <= SLEEP_B;
        VPWR_reg <= VPWR;
        VGND_reg <= VGND;
        VPB_reg <= VPB;
        VNB_reg <= VNB;
    end
end

endmodule