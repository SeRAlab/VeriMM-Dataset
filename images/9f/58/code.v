module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    output X
);wire [3:0] sum;
    assign sum = A1 + A2 + B1 + B2;
    
    assign X = (A1 == 1) ? (sum[1:0] + B1 + B2) : sum[3:0];
    
endmodule