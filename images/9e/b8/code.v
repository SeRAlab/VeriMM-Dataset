module top_module(
    input CLK,
    input D,
    input SCD,
    input SCE,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N
);always @(posedge CLK) begin
        if (SCD) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (!SCE) begin
            Q <= Q;
            Q_N <= Q_N;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule