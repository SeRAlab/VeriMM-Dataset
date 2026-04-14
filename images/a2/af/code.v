module top_module(
    input A,
    input B,
    input C,
    input D,
    output X,
    output Y
);wire temp_X;

    assign temp_X = (A == 1'b1) ? (B & C) : (B | C);
    assign Y = temp_X ^ D;
    assign X = temp_X;

endmodule