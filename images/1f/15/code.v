module rrt_node_selector (
    input [7:0] x1, y1,   // Coordinates of the first point
    input [7:0] x2, y2,   // Coordinates of the second point
    output reg [7:0] nearest_x, nearest_y // Nearest node coordinates
);
    
    // Internal variables to store distances
    reg [15:0] dist1, dist2;

    always @(*) begin
        // Calculate squared distances to avoid floating point operations
        dist1 = (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2);
        dist2 = (x1)*(x1) + (y1)*(y1); // distance from origin
        
        // Select nearest node based on distance
        if (dist1 < dist2) begin
            nearest_x = x2;
            nearest_y = y2;
        end else begin
            nearest_x = 0; // Using origin as a default node
            nearest_y = 0;
        end
    end
endmodule