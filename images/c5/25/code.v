module decoder_2to4 (
    input A,
    input B,
    output reg Y0,
    output reg Y1,
    output reg Y2,
    output reg Y3
);

    always @ (A, B) begin
        Y0 = ~(A | B);
        Y1 = ~(A & B);
        Y2 = ~((~A) & B);
        Y3 = ~(~A | ~B);
    end

endmodule