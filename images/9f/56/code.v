module top_module(
    input D,
    input SCD,
    input SCE,
    input RESET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q,
    input CLK
);reg Q_reg;
    always @(posedge CLK) begin
        if (VPWR == 1'b1) begin
            Q_reg <= 1'b0;
        end else if (RESET_B == 1'b0) begin
            Q_reg <= 1'b0;
        end else if (SCD == 1'b0 && SCE == 1'b1) begin
            Q_reg <= 1'b0;
        end else if (SCD == 1'b1 && SCE == 1'b0) begin
            Q_reg <= 1'b1;
        end else if (SCD == 1'b1 && SCE == 1'b1) begin
            Q_reg <= Q_reg;
        end else begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule