module perceptron(
    input wire clk,
    input wire [7:0] x1,
    input wire [7:0] x2,
    input wire [7:0] x3,
    input wire [7:0] w1,
    input wire [7:0] w2,
    input wire [7:0] w3,
    input wire [7:0] threshold,
    output reg y
);
    reg [15:0] weighted_sum;

    always @(posedge clk) begin
        weighted_sum <= (x1 * w1) + (x2 * w2) + (x3 * w3);
        if (weighted_sum > threshold)
            y <= 1'b1;
        else
            y <= 1'b0;
    end
endmodule