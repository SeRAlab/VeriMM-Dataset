module top_module(A, B, Cin, S, Cout);input A, B, Cin;
    output S, Cout;
    wire AxorB, AandB, AxorBandCin;

    assign AxorB = A ^ B;
    assign S = AxorB ^ Cin;
    assign AandB = A & B;
    assign AxorBandCin = AxorB & Cin;
    assign Cout = AandB | AxorBandCin;
endmodule