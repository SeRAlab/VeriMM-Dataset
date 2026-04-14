module logistic_regression (
    input wire x1,
    input wire x2,
    output wire y
);
    wire [3:0] weighted_sum;
    
    assign weighted_sum = (3 * x1) + (5 * x2);
    assign y = (weighted_sum >= 4) ? 1'b1 : 1'b0;

endmodule