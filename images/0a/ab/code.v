module kmeans_centroid_calc(  
    input [7:0] x1,  
    input [7:0] y1,  
    input [7:0] x2,  
    input [7:0] y2,  
    output reg [7:0] centroid_x,  
    output reg [7:0] centroid_y  
);  
    always @(*) begin  
        centroid_x = (x1 + x2) >> 1;  
        centroid_y = (y1 + y2) >> 1;  
    end  
endmodule