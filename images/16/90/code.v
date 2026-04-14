module kmeans_selector(  
    input [7:0] centroid_x,  
    input [7:0] centroid_y,  
    input [7:0] point1_x,  
    input [7:0] point1_y,  
    input [7:0] point2_x,  
    input [7:0] point2_y,  
    output reg [1:0] closest_point  
);  
    wire [15:0] dist1, dist2;  

    assign dist1 = (centroid_x - point1_x) * (centroid_x - point1_x) + (centroid_y - point1_y) * (centroid_y - point1_y);  
    assign dist2 = (centroid_x - point2_x) * (centroid_x - point2_x) + (centroid_y - point2_y) * (centroid_y - point2_y);  

    always @(*) begin  
        if (dist1 < dist2)  
            closest_point = 2'b01;  // Point 1 is closer  
        else  
            closest_point = 2'b10;  // Point 2 is closer  
    end  
endmodule