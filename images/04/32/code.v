module rrt_nearest_point(  
    input [4:0] random_point,  
    output reg [4:0] nearest_point  
);  
    // Predefined set of points  
    reg [4:0] points [0:4];  
    integer i;  
    reg [4:0] min_distance;  
    reg [4:0] current_distance;  
    initial begin  
        points[0] = 5'b00001;  
        points[1] = 5'b00010;  
        points[2] = 5'b00011;  
        points[3] = 5'b00100;  
        points[4] = 5'b00101;  
    end  
      
    always @(*) begin  
        nearest_point = 5'b00000;  
        min_distance = 5'b11111; // Initialize to max value  
        for (i = 0; i < 5; i = i + 1) begin  
            // Calculate Manhattan distance  
            current_distance = (random_point[4:0] ^ points[i][4:0]) & 5'b11111;  
            if (current_distance < min_distance) begin  
                min_distance = current_distance;  
                nearest_point = points[i];  
            end  
        end  
    end  
endmodule