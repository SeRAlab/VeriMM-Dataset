module logistic_regression (
    input [7:0] x0,
    input [7:0] x1,
    input [7:0] x2,
    output reg y
);
    wire signed [15:0] weighted_sum;
    
    assign weighted_sum = (1 * x0) + (2 * x1) + (3 * x2) - 4;

    always @(*) begin
        if (weighted_sum >= 0) 
            y = 1;
        else 
            y = 0;
    end
endmodule