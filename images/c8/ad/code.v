module xor_and (
    input A,
    input B,
    input C,
    output X
);

assign X = (A ^ B) & C;

endmodule