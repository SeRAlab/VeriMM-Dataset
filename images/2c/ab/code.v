module polynomial_evaluator (
    input [7:0] x,            // Input value for x
    input [7:0] a0,           // Coefficient a0
    input [7:0] a1,           // Coefficient a1
    input [7:0] a2,           // Coefficient a2
    input [7:0] a3,           // Coefficient a3
    output reg [15:0] result   // Output polynomial result
);
    always @(*) begin
        result = (a3 * x * x * x) + (a2 * x * x) + (a1 * x) + a0;
    end
endmodule