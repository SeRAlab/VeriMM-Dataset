module perceptron (
    input wire x1,
    input wire x2,
    output reg y
);
    parameter w1 = 1;
    parameter w2 = -1;
    parameter b = 0;

    always @(*) begin
        if ((w1 * x1 + w2 * x2 + b) >= 0)
            y = 1;
        else
            y = 0;
    end
endmodule