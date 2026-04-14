module cholesky_decomposition(
    input clk,
    input enable,
    input [7:0] a11, a12, a21, a22,
    output reg [7:0] l11, l21, l22
);
    always @(posedge clk) begin
        if (enable) begin
            l11 <= a11 ** 0.5; // l11 = sqrt(a11)
            l21 <= a21 / l11; // l21 = a21 / l11
            l22 <= (a22 - l21 * l21) ** 0.5; // l22 = sqrt(a22 - l21^2)
        end
    end
endmodule