module logistic_regression #(  
    parameter w1 = 8'd5,  
    parameter w2 = 8'd3,  
    parameter b = 8'd2  
) (  
    input [7:0] x1,  
    input [7:0] x2,  
    output reg [7:0] p  
);  
    wire signed [15:0] weighted_sum;  
    wire signed [15:0] exp_neg;  
    wire signed [15:0] denominator;  

    assign weighted_sum = (w1 * x1) + (w2 * x2) + b;  
    assign exp_neg = (weighted_sum < 0) ? (1 << (-weighted_sum)) : 0;  
    assign denominator = 1 + exp_neg;  

    always @(*) begin  
        p = (denominator > 0) ? (256 / denominator) : 0;  
    end  
endmodule