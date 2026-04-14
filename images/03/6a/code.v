module AStarFSM (  
    input [3:0] current_state,  
    input [7:0] heuristic_cost,  
    input [7:0] actual_cost,  
    output reg [3:0] next_state  
);  
    always @(current_state or heuristic_cost or actual_cost) begin  
        case (current_state)  
            4'b0000: next_state = (heuristic_cost + actual_cost < 100) ? 4'b0001 : 4'b0000;  
            4'b0001: next_state = (heuristic_cost + actual_cost < 150) ? 4'b0010 : 4'b0000;  
            4'b0010: next_state = (heuristic_cost + actual_cost < 200) ? 4'b0011 : 4'b0000;  
            4'b0011: next_state = (heuristic_cost + actual_cost < 250) ? 4'b0100 : 4'b0000;  
            4'b0100: next_state = 4'b0000;  
            default: next_state = 4'b0000;  
        endcase  
    end  
endmodule