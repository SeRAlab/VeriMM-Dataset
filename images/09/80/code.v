module kmeans_clustering (
    input clk,
    input reset,
    input [7:0] data_point,
    input valid_data,
    output reg [7:0] centroid_0,
    output reg [7:0] centroid_1,
    output reg [7:0] centroid_2,
    output reg [7:0] centroid_3
);
    reg [7:0] sum_0, sum_1, sum_2, sum_3;
    reg count_0, count_1, count_2, count_3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            centroid_0 <= 8'b0;
            centroid_1 <= 8'b0;
            centroid_2 <= 8'b0;
            centroid_3 <= 8'b0;
            sum_0 <= 8'b0;
            sum_1 <= 8'b0;
            sum_2 <= 8'b0;
            sum_3 <= 8'b0;
            count_0 <= 0;
            count_1 <= 0;
            count_2 <= 0;
            count_3 <= 0;
        end else if (valid_data) begin
            // Simple assignment for demonstration purposes
            if (data_point < 64) begin
                sum_0 <= sum_0 + data_point;
                count_0 <= count_0 + 1;
                centroid_0 <= sum_0 / count_0;
            end else if (data_point < 128) begin
                sum_1 <= sum_1 + data_point;
                count_1 <= count_1 + 1;
                centroid_1 <= sum_1 / count_1;
            end else if (data_point < 192) begin
                sum_2 <= sum_2 + data_point;
                count_2 <= count_2 + 1;
                centroid_2 <= sum_2 / count_2;
            end else begin
                sum_3 <= sum_3 + data_point;
                count_3 <= count_3 + 1;
                centroid_3 <= sum_3 / count_3;
            end
        end
    end
endmodule