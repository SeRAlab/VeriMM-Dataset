module a_star_heuristic(  
    input [3:0] g_cost,  
    input [3:0] h_cost,  
    output [4:0] f_cost  
);  
    assign f_cost = g_cost + h_cost;  
endmodule