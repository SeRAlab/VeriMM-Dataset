module polynomial_evaluator (
    input [3:0] x,
    output reg [9:0] P
);
    always @(*) begin
        P = 3 * (x * x * x) + 2 * (x * x) + 1; // Evaluate the polynomial
    end
endmodule