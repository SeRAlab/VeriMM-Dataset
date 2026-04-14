module top_module(
    input D,
    input SCD,
    input SCE,
    input CLK_N,
    input SET_B,
    input RESET_B,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N
);wire CLK = ~CLK_N;
    wire S = SCE & ~SCD;
    wire R = SCD & ~SCE;
    wire AS = SET_B & VPWR & VNB;
    wire AR = RESET_B & VPWR & VNB;

    always @(posedge CLK) begin
        if (S) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (R) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (AS) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (AR) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule