module svm_decision_boundary (
    input wire x,  // 1-bit input for x coordinate
    input wire y,  // 1-bit input for y coordinate
    output wire decision  // 1-bit output for decision
);
    assign decision = (x + y) > 1 ? 1'b1 : 1'b0;
endmodule