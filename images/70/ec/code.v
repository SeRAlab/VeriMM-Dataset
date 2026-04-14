module top_module(
    input wire D,
    input wire DE,
    input wire VPWR,
    input wire VGND,
    input wire VPB,
    input wire VNB,
    input wire CLK,
    output reg Q,
    output reg Q_N
);// Asynchronous reset
    always @ (VGND or VPWR)
    begin
        if (VGND == 0 || VPWR == 1) begin
            Q <= 0;
            Q_N <= 1;
        end
    end

    // Positive edge-triggered flip-flop
    always @ (posedge CLK)
    begin
        if (DE == 1) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule