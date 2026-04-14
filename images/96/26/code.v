module top_module(
    output Q,
    input CLK,
    input D,
    input SCD,
    input SCE,
    input RESET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);reg Q_reg;

    always @ (posedge CLK) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else if (SCE) begin
            Q_reg <= SCD;
        end else begin
            Q_reg <= D;
        end
    end

    assign Q = Q_reg;

endmodule