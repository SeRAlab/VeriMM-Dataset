module logistic_regression (
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    input [7:0] x4,
    input [7:0] x5,
    output reg class_label
);

    wire signed [15:0] weighted_sum;

    assign weighted_sum = (1 * x1) + (2 * x2) + (3 * x3) + (4 * x4) + (5 * x5) - 10;

    always @(*) begin
        if (weighted_sum >= 0) begin
            class_label = 1;
        end else begin
            class_label = 0;
        end
    end
endmodule