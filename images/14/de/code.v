module AStarSearch(  
    input [3:0] start_x,  
    input [3:0] start_y,  
    input [3:0] goal_x,  
    input [3:0] goal_y,  
    input [3:0] move_cost,  
    output reg [7:0] total_cost  
);  

    always @(*) begin  
        // Simple A* heuristic cost calculation (Manhattan Distance + Move Cost)  
        total_cost = (abs(start_x - goal_x) + abs(start_y - goal_y) + move_cost);  
    end  

    function [3:0] abs;  
        input [3:0] value;  
        begin  
            abs = (value < 0) ? -value : value;  
        end  
    endfunction  
endmodule