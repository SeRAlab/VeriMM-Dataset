module kmeans_clustering(  
    input [7:0] point_x,  
    input [7:0] point_y,  
    input [7:0] centroid1_x,  
    input [7:0] centroid1_y,  
    input [7:0] centroid2_x,  
    input [7:0] centroid2_y,  
    output reg [1:0] cluster  
);  
  
    wire [15:0] dist1, dist2;  
  
    assign dist1 = (point_x - centroid1_x) * (point_x - centroid1_x) + (point_y - centroid1_y) * (point_y - centroid1_y);  
    assign dist2 = (point_x - centroid2_x) * (point_x - centroid2_x) + (point_y - centroid2_y) * (point_y - centroid2_y);  
  
    always @(*) begin  
        if (dist1 < dist2)  
            cluster = 2'b00; // Assign to cluster 1  
        else  
            cluster = 2'b01; // Assign to cluster 2  
    end  
endmodule