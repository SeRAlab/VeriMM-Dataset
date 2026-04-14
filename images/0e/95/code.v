module polynomial_evaluator (
    input [3:0] x,
    input [9:0] a0, 
    input [9:0] a1, 
    input [9:0] a2, 
    input [9:0] a3,
    output reg [9:0] result
);
    always @(*) begin
        result = a0 + (a1 * x) + (a2 * (x * x)) + (a3 * (x * x * x));
    end
endmodule