module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    input C1,
    input C2,
    output Y
);wire sum;
    assign sum = A1 + A2 + B1 + B2 + C1 + C2;

    assign Y = (sum >= 4) ? 1'b1 : 1'b0;

endmodule