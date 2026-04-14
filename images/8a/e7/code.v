module top_module(
    input A,
    input B,
    input C,
    output reg Y0,
    output reg Y1,
    output reg Y2,
    output reg Y3,
    output reg Y4,
    output reg Y5,
    output reg Y6,
    output reg Y7
);always @ (A or B or C) begin
    Y0 = ~(A | B | C);
    Y1 = ~(A | B | ~C);
    Y2 = ~(A | ~B | C);
    Y3 = ~(A | ~B | ~C);
    Y4 = ~(~A | B | C);
    Y5 = ~(~A | B | ~C);
    Y6 = ~(~A | ~B | C);
    Y7 = ~(~A | ~B | ~C);
end

endmodule