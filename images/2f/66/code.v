module logistic_regression (
    input [7:0] x1,
    input [7:0] x2,
    input [7:0] x3,
    output reg y
);
    parameter w1 = 8'b01000000; // 0.5 in fixed-point
    parameter w2 = 8'b10111111; // -0.5 in fixed-point
    parameter w3 = 8'b00000001; // 1.0 in fixed-point
    
    wire signed [15:0] z;
    wire signed [15:0] exp_neg_z;

    assign z = (w1 * x1) + (w2 * x2) + (w3 * x3);
    assign exp_neg_z = (z < 0) ? (1 << 15) / (1 + ((-z) >> 2)) : (1 << 15) / (1 + (z >> 2));

    always @(*) begin
        if (z < 0) begin
            y = (exp_neg_z < (1 << 15)) ? 1 : 0;
        end else begin
            y = (exp_neg_z < (1 << 15)) ? 0 : 1;
        end
    end
endmodule