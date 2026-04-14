module svm_decision_function (
    input wire x1,
    input wire x2,
    input wire x3,
    output wire y
);
    assign y = (x1 * 1 + x2 * 2 + x3 * 1) > 1 ? 1 : 0;
endmodule