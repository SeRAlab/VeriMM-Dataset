module my_mux(
    input A,
    input B,
    input S,
    output O
);

assign O = (S == 1'b0) ? A : B;

endmodule