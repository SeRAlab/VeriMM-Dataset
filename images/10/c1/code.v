module logistic_regression (
    input wire x1,
    input wire x2,
    output wire y
);
    assign y = (x1 + x2 > 1) ? 1 : 0;
endmodule