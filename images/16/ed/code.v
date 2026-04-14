module DWT(
    input clk,
    input rst,
    input [7:0] data_in_0,
    input [7:0] data_in_1,
    input [7:0] data_in_2,
    input [7:0] data_in_3,
    output reg [7:0] approx_out_0,
    output reg [7:0] approx_out_1
);
    reg [8:0] sum_0, sum_1;
    reg [8:0] diff_0, diff_1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            approx_out_0 <= 8'b0;
            approx_out_1 <= 8'b0;
        end else begin
            sum_0 = data_in_0 + data_in_1;
            sum_1 = data_in_2 + data_in_3;
            diff_0 = data_in_0 - data_in_1;
            diff_1 = data_in_2 - data_in_3;

            approx_out_0 <= sum_0[8:1]; // Approximation coefficient
            approx_out_1 <= sum_1[8:1]; // Approximation coefficient
        end
    end
endmodule