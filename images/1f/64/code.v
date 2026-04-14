module polynomial_evaluator (
    input [3:0] a3, a2, a1, a0, // coefficients
    input [3:0] x,               // variable input
    output reg [7:0] result      // evaluated output
);

always @(*) begin
    result = (a3 * x * x * x) + (a2 * x * x) + (a1 * x) + a0;
end

endmodule