module polynomial_evaluator (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] x,
    output reg [15:0] result
);
    
    always @(*) begin
        result = (a * x * x) + (b * x) + c;
    end
endmodule