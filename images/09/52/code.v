module kmeans_clustering(
    input wire clk,
    input wire rst,
    input wire [7:0] data_point,
    input wire [2:0] cluster_id,
    input wire valid,
    output reg [7:0] centroid_0,
    output reg [7:0] centroid_1,
    output reg [7:0] centroid_2,
    output reg [7:0] centroid_3,
    output reg [7:0] centroid_4
);
    reg [3:0] count[0:4]; // Count of points assigned to each cluster
    reg [15:0] sum[0:4];   // Sum of points assigned to each cluster

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            centroid_0 <= 8'd0;
            centroid_1 <= 8'd0;
            centroid_2 <= 8'd0;
            centroid_3 <= 8'd0;
            centroid_4 <= 8'd0;
            for (i = 0; i < 5; i = i + 1) begin
                count[i] <= 4'd0;
                sum[i] <= 16'd0;
            end
        end
        else if (valid) begin
            sum[cluster_id] <= sum[cluster_id] + data_point;
            count[cluster_id] <= count[cluster_id] + 1;
            if (count[cluster_id] != 0) begin
                if (cluster_id == 3'd0) centroid_0 <= sum[0] / count[0];
                else if (cluster_id == 3'd1) centroid_1 <= sum[1] / count[1];
                else if (cluster_id == 3'd2) centroid_2 <= sum[2] / count[2];
                else if (cluster_id == 3'd3) centroid_3 <= sum[3] / count[3];
                else if (cluster_id == 3'd4) centroid_4 <= sum[4] / count[4];
            end
        end
    end
endmodule