module kmeans_clustering(
    input clk,
    input rst,
    input start,
    input [7:0] data_point,
    output reg [7:0] centroid1,
    output reg [7:0] centroid2,
    output reg done
);
    parameter MAX_ITERATIONS = 5;
    reg [2:0] count;
    reg [7:0] sum1, sum2;
    reg [3:0] size1, size2;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            centroid1 <= 8'd0;
            centroid2 <= 8'd0;
            count <= 3'd0;
            sum1 <= 8'd0;
            sum2 <= 8'd0;
            size1 <= 4'd0;
            size2 <= 4'd0;
            done <= 1'b0;
        end else if (start) begin
            if (count < MAX_ITERATIONS) begin
                // Assign data points to closest centroid
                if (data_point < (centroid1 + centroid2) / 2) begin
                    sum1 <= sum1 + data_point;
                    size1 <= size1 + 1;
                end else begin
                    sum2 <= sum2 + data_point;
                    size2 <= size2 + 1;
                end
                count <= count + 1;
            end else if (count == MAX_ITERATIONS) begin
                // Update centroids
                if (size1 > 0) centroid1 <= sum1 / size1;
                if (size2 > 0) centroid2 <= sum2 / size2;
                done <= 1'b1;
            end
        end
    end
endmodule