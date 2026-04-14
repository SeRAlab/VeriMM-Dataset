module top_module(
    input D,
    input RESET_B,
    input CLK,
    output Q,
    output Q_N
);wire nand1_out;
    wire nand2_out;
    wire nand3_out;
    wire nand4_out;
    wire nand5_out;
    wire nand6_out;
    wire nand7_out;
    
    // Using built-in NAND gate operation
    wire D_bar;
    wire CLK_bar;
    
    assign D_bar = ~D;
    assign CLK_bar = ~CLK;
    
    assign nand1_out = ~(D & CLK);         // NAND gate 1
    assign nand2_out = ~(nand1_out & RESET_B); // NAND gate 2
    assign nand3_out = ~(nand1_out & nand4_out); // NAND gate 3
    assign nand4_out = ~(nand2_out & nand3_out); // NAND gate 4
    assign nand5_out = ~(nand4_out & CLK); // NAND gate 5
    assign nand6_out = ~(nand4_out & nand7_out); // NAND gate 6
    assign nand7_out = ~(nand5_out & nand6_out); // NAND gate 7
    assign Q_N = ~(nand6_out & RESET_B); // Output Q_N
    
    assign Q = ~Q_N; // Q is the inverse of Q_N
endmodule