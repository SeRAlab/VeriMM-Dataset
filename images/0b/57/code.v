module logistic_regression (
    input signed [3:0] x,
    output reg signed [3:0] y
);
    always @(*) begin
        if (x < 0)
            y = 0; // sigmoid approximation for negative inputs
        else if (x >= 0 && x <= 4)
            y = x; // linear approximation for small positive inputs
        else
            y = 4; // capped output for large positive inputs
    end
endmodule