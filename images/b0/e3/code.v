module top_module(
    input  D      ,
    output Q      ,
    input  RESET_B,
    input  GATE   ,
    input  VPB    ,
    input  VPWR   ,
    input  VGND   ,
    input  VNB
);reg Q_reg;
    assign Q = Q_reg;

    always @(posedge GATE or negedge RESET_B) begin
        if (!RESET_B) begin
            Q_reg <= 1'b0;
        end else if (GATE) begin
            Q_reg <= D;
        end else begin
            Q_reg <= VPB - VPWR + VGND - VNB;
        end
    end

endmodule