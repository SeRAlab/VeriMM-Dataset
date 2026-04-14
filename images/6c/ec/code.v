module top_module(
    input A,
    input B,
    input C,
    input D,
    input S0,
    input S1,
    input [1:0] D_in,
    output Y
);// 2-to-4 decoder using Cooley-Tukey algorithm for radix-2 FFT
    wire [3:0] Q;
    assign Q[0] = ~(D_in[0] & D_in[1]);
    assign Q[1] = ~(D_in[0] & ~D_in[1]);
    assign Q[2] = ~(~D_in[0] & D_in[1]);
    assign Q[3] = ~(~D_in[0] & ~D_in[1]);

    // 4-to-1 transmission gate multiplexer
    wire Mux_A, Mux_B, Mux_C, Mux_D;
    assign Mux_A = A & Q[0];
    assign Mux_B = B & Q[1];
    assign Mux_C = C & Q[2];
    assign Mux_D = D & Q[3];

    // Output selection based on select inputs
    assign Y = (S1 & S0) ? Mux_D : (S1 & ~S0) ? Mux_C : (~S1 & S0) ? Mux_B : Mux_A;

endmodule