module top_module(
    input D,
    input RESET_B,
    input GATE_N,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N
);wire GATE;
    assign GATE = ~GATE_N;

    // Internal state
    always @(posedge GATE or negedge RESET_B) begin
        if (~RESET_B) begin
            Q <= 1'b0;  // Reset Q to 0 on reset
            Q_N <= 1'b1; // Reset Q_N to 1 on reset
        end else begin
            Q <= D;     // Latch value of D
            Q_N <= ~D;  // Inverted value of D
        end
    end

endmodule