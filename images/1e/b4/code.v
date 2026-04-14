module AStarSearch(  
    input [3:0] current_cost,  
    input [3:0] heuristic_cost,  
    input [3:0] total_cost,  
    output reg [3:0] next_step  
);  
    always @(*) begin  
        if ((current_cost + heuristic_cost) <= total_cost)  
            next_step = current_cost + heuristic_cost;  
        else  
            next_step = total_cost;  
    end  
endmodule