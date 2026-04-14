module top_module(
    input A,
    input B,
    input C1,
    output Y
);assign Y = (C1 == 1'b1) ? (A & B) : 1'b0;

endmodule