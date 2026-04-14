module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    output X
);assign X = (A1 === 1'b1 && A2 === 1'b1 && A3 === 1'b1 && B1 === 1'b1) ? 1'b1 :
               (A1 === 1'b0 && A2 === 1'b0 && A3 === 1'b0 && B1 === 1'b0) ? 1'b0 :
               1'bx;

endmodule