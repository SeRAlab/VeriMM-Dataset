module polynomial_evaluator (
    input [3:0] a4,
    input [3:0] a3,
    input [3:0] a2,
    input [3:0] a1,
    input [3:0] a0,
    input [3:0] x,
    output reg [7:0] P
);
    always @(*) begin
        P = (a4 * x * x * x * x) + 
            (a3 * x * x * x) + 
            (a2 * x * x) + 
            (a1 * x) + 
            a0;
    end
endmodule