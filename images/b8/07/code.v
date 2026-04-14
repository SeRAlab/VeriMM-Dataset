module top_module(
    X  ,
    A  ,
    B  ,
    C_N,
    D_N
);// Module ports
    output X  ;
    input  A  ;
    input  B  ;
    input  C_N;
    input  D_N;

    // Local signals
    wire nand0_out;
    wire or0_out_X;

    // Logic gates using standard Verilog primitives
    assign nand0_out = ~(C_N & D_N); // NAND gate implementation
    assign or0_out_X = A | B | nand0_out; // OR gate implementation
    assign X = or0_out_X; // Buffer output

endmodule