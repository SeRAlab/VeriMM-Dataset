module top_module(
    input  wire D,
    input  wire DE,
    input  wire SCD,
    input  wire SCE,
    input  wire VPWR,
    input  wire VGND,
    input  wire VPB,
    input  wire VNB,
    output reg  Q,
    output reg  Q_N,
    input  wire CLK
);always @(posedge CLK) begin
        if (D == 1'b0 && DE == 1'b0 && SCD == 1'b0 && SCE == 1'b0 && VPWR == 1'b0 && VGND == 1'b0 && VPB == 1'b0 && VNB == 1'b0) begin
            Q    <= 1'b0;
            Q_N  <= 1'b1;
        end else if (D == 1'b1 && DE == 1'b1 && SCD == 1'b1 && SCE == 1'b1 && VPWR == 1'b1 && VGND == 1'b1 && VPB == 1'b1 && VNB == 1'b1) begin
            Q    <= 1'b1;
            Q_N  <= 1'b0;
        end else begin
            Q    <= 1'bx;
            Q_N  <= 1'bx;
        end
    end

endmodule