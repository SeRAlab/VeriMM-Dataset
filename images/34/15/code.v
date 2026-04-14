module a_star_heuristic (
    input [3:0] current_node,
    input [3:0] target_node,
    output [3:0] heuristic_cost
);
    wire [3:0] x_diff;
    wire [3:0] y_diff;

    assign x_diff = (current_node[3:2] > target_node[3:2]) ? (current_node[3:2] - target_node[3:2]) : (target_node[3:2] - current_node[3:2]);
    assign y_diff = (current_node[1:0] > target_node[1:0]) ? (current_node[1:0] - target_node[1:0]) : (target_node[1:0] - current_node[1:0]);
    
    assign heuristic_cost = x_diff + y_diff;
endmodule