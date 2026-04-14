module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    output Y
);wire w1, w2;

assign w1 = C1 ? B1 : A1;
assign w2 = C1 ? B2 : A2;

assign Y = C1 ? w1 : w2;

endmodule