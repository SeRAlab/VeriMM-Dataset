module dijkstra_min_distance(  
    input [7:0] dist1,  
    input [7:0] dist2,  
    input [7:0] dist3,  
    output reg [7:0] min_dist  
);  
    always @(*) begin  
        if (dist1 <= dist2 && dist1 <= dist3)  
            min_dist = dist1;  
        else if (dist2 <= dist1 && dist2 <= dist3)  
            min_dist = dist2;  
        else  
            min_dist = dist3;  
    end  
endmodule