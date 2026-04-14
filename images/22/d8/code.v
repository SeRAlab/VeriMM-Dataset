module kmeans_clustering (
    input clk,
    input rst,
    input [3:0] data_in,
    input [3:0] iterations,
    input valid,
    output reg [3:0] centroid1,
    output reg [3:0] centroid2,
    output reg ready
);
    reg [3:0] sum1, sum2;
    reg [3:0] count1, count2;
    integer i;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            centroid1 <= 4'b0000;
            centroid2 <= 4'b0000;
            sum1 <= 4'b0000;
            sum2 <= 4'b0000;
            count1 <= 4'b0000;
            count2 <= 4'b0000;
            ready <= 1'b0;
        end else begin
            if (valid) begin
                // Assign data point to the nearest centroid
                if (data_in < (centroid1 + centroid2) >> 1) begin
                    sum1 <= sum1 + data_in;
                    count1 <= count1 + 1;
                end else begin
                    sum2 <= sum2 + data_in;
                    count2 <= count2 + 1;
                end
            end
            
            // Update centroids after the specified iterations
            if (i < iterations) begin
                if (count1 != 0) centroid1 <= sum1 / count1;
                if (count2 != 0) centroid2 <= sum2 / count2;
                i <= i + 1;
            end else begin
                ready <= 1'b1; // Indicate that clustering is complete
            end
        end
    end
endmodule