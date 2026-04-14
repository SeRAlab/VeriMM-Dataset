module top_module(
    input wire D,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    output reg Q,
    output reg Q_N,
    input wire CLK
);always @(posedge CLK or negedge VPWR or negedge VGND or negedge VPB or negedge VNB) begin
        if (~VPWR) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (~VGND) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (~VPB) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (~VNB) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule