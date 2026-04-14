module knn_distance(  
    input [15:0] point1_x,  
    input [15:0] point1_y,  
    input [15:0] point1_z,  
    input [15:0] point2_x,  
    input [15:0] point2_y,  
    input [15:0] point2_z,  
    input [15:0] point3_x,  
    input [15:0] point3_y,  
    input [15:0] point3_z,  
    input [15:0] query_x,  
    input [15:0] query_y,  
    input [15:0] query_z,  
    output reg [31:0] distance1,  
    output reg [31:0] distance2,  
    output reg [31:0] distance3  
);  
    always @(*) begin  
        distance1 = (point1_x - query_x) * (point1_x - query_x) +  
                    (point1_y - query_y) * (point1_y - query_y) +  
                    (point1_z - query_z) * (point1_z - query_z);  
        distance2 = (point2_x - query_x) * (point2_x - query_x) +  
                    (point2_y - query_y) * (point2_y - query_y) +  
                    (point2_z - query_z) * (point2_z - query_z);  
        distance3 = (point3_x - query_x) * (point3_x - query_x) +  
                    (point3_y - query_y) * (point3_y - query_y) +  
                    (point3_z - query_z) * (point3_z - query_z);  
    end  
endmodule