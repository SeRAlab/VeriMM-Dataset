module d_flip_flop(
    input wire clk,
    input wire D,
    output wire Q,
    output wire Qn
);
    wire S;
    wire R;
    
    assign S = D & clk;     // Set condition
    assign R = ~D & clk;    // Reset condition

    // SR-latch implementation using NAND gates
    wire R_latch, S_latch;
    nand (S_latch, S, Qn);
    nand (R_latch, R, Q);
    
    assign Q = S_latch;
    assign Qn = R_latch;

endmodule