module knn_compare(  
    input [3:0] point_a,  
    input [3:0] point_b,  
    output reg neighbor  
);  
    wire [3:0] diff_x;  
    wire [3:0] diff_y;  
    wire [3:0] manhattan_distance;  

    assign diff_x = (point_a[3:2] > point_b[3:2]) ? (point_a[3:2] - point_b[3:2]) : (point_b[3:2] - point_a[3:2]);  
    assign diff_y = (point_a[1:0] > point_b[1:0]) ? (point_a[1:0] - point_b[1:0]) : (point_b[1:0] - point_a[1:0]);  
    assign manhattan_distance = diff_x + diff_y;  

    always @(*) begin  
        if (manhattan_distance <= 4'd3)  
            neighbor = 1'b1;  
        else  
            neighbor = 1'b0;  
    end  
endmodule