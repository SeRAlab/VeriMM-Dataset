module AStarHeuristic(
    input [3:0] current_cost,
    input [3:0] heuristic,
    output [3:0] f_cost
);
    assign f_cost = (current_cost + heuristic > 4'b1111) ? 4'b1111 : (current_cost + heuristic);
endmodule