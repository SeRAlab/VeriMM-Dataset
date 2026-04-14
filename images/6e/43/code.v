module top_module(
    A,
    B,
    C,
    D,
    Y
);input A, B, C, D;
    output Y;

    wire AandB, AandC, AandD, BandC, BandD, CandD;
    wire majority1, majority2, majority3, majority4;

    // Calculate all possible pairs of AND gates
    and (AandB, A, B);
    and (AandC, A, C);
    and (AandD, A, D);
    and (BandC, B, C);
    and (BandD, B, D);
    and (CandD, C, D);

    // Calculate majority for each group of 3 inputs
    assign majority1 = (AandB & C) | (AandC & B) | (AandD & B) | (BandC & A) | (BandD & A) | (CandD & A);
    assign majority2 = (AandB & D) | (AandC & D) | (AandD & C) | (BandC & D) | (BandD & C) | (CandD & B);
    assign majority3 = (AandB & C) | (AandC & D) | (AandD & B) | (BandC & D) | (BandD & A) | (CandD & B);
    assign majority4 = (AandB & D) | (AandC & B) | (AandD & C) | (BandC & A) | (BandD & C) | (CandD & A);

    // Calculate final majority function
    assign Y = majority1 & majority2 | majority1 & majority3 | majority1 & majority4 | majority2 & majority3 | majority2 & majority4 | majority3 & majority4;

endmodule