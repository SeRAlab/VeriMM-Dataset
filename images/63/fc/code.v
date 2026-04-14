module top_module(
    Q,
    CLK,
    D,
    RESET_B,
    VPWR,
    VGND,
    VPB,
    VNB
);output Q;
    input CLK, D, RESET_B, VPWR, VGND, VPB, VNB;

    reg Q;

    // Synchronize the data input with the system clock
    always @(posedge CLK or negedge RESET_B) begin
        if (~RESET_B) begin
            Q <= 1'b0; // Reset to default value
        end else begin
            Q <= D;
        end
    end

endmodule