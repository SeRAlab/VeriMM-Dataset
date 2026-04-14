module top_module(
    input RESET_B,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Q,
    output reg Q_N,
    input GATE_N
);// Asynchronous reset behavior
    always @(posedge GATE_N or negedge RESET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0; // Active-low reset
            Q_N <= 1'b1;
        end else begin
            Q <= D;    // Non-blocking assignment for D flip-flop
            Q_N <= ~D; // Inverted output
        end
    end

endmodule