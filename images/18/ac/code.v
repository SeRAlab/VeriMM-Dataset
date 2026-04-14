module polynomial_evaluator (
    input [3:0] x,
    output reg [7:0] P_out
);
    parameter a = 2; // Example coefficients
    parameter b = 3;
    parameter c = 1;
    parameter d = 5;

    always @(*) begin
        P_out = (a * x * x * x) + (b * x * x) + (c * x) + d;
    end
endmodule