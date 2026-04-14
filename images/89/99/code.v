module top_module(
    input  D,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB,
    output Q,
    output Q_N,
    input  GATE_N
);reg Q_reg;
    reg Q_N_reg;

    always @(posedge GATE_N or negedge VPB or negedge VNB) begin
        if (VPB == 1'b0) begin
            Q_reg <= 1'b0;
            Q_N_reg <= 1'b1;
        end else if (VNB == 1'b0) begin
            Q_reg <= 1'b1;
            Q_N_reg <= 1'b0;
        end else begin
            Q_reg <= D;
            Q_N_reg <= ~D;
        end
    end

    assign Q = Q_reg;
    assign Q_N = Q_N_reg;

endmodule