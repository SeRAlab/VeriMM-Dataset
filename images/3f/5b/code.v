module a_star_search(input [24:0] grid, input [4:0] start, input [4:0] goal, output reg [24:0] path);  
    integer i;  
    reg [24:0] temp_path;  
    always @(*) begin  
        temp_path = 25'b0;  
        // A simplified version of A* assuming a straight line path and no obstacles for simplicity  
        if (grid[start] && grid[goal]) begin  
            temp_path[start] = 1;  
            for (i = 1; i <= 5; i = i + 1) begin  
                if (start + i < 25 && grid[start + i])  
                    temp_path[start + i] = 1;  
                if (goal - i >= 0 && grid[goal - i])  
                    temp_path[goal - i] = 1;  
            end  
        end  
        path = temp_path;  
    end  
endmodule