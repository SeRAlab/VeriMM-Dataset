module kmeans_clustering(  
    input [7:0] point_x,  
    input [7:0] point_y,  
    input [7:0] center0_x,  
    input [7:0] center0_y,  
    input [7:0] center1_x,  
    input [7:0] center1_y,  
    output reg [0:0] nearest_center  
);  

wire [15:0] dist0, dist1;  

// Calculate Euclidean distance squared for center 0  
assign dist0 = (point_x - center0_x) * (point_x - center0_x) + (point_y - center0_y) * (point_y - center0_y);  
// Calculate Euclidean distance squared for center 1  
assign dist1 = (point_x - center1_x) * (point_x - center1_x) + (point_y - center1_y) * (point_y - center1_y);  

always @(*) begin  
    if (dist0 < dist1)  
        nearest_center = 1'b0;  
    else  
        nearest_center = 1'b1;  
end  
endmodule