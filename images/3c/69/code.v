module AStarSearch (
    input clk,
    input rst,
    input [7:0] g_cost, // cost from start to current node
    input [7:0] h_cost, // heuristic cost to goal
    input add_node,     // signal to add node to open list
    input move_node,    // signal to move node to closed list
    output reg [7:0] f_cost, // total cost f = g + h
    output reg [7:0] open_list_count, // count of nodes in open list
    output reg [7:0] closed_list_count // count of nodes in closed list
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            f_cost <= 0;
            open_list_count <= 0;
            closed_list_count <= 0;
        end else begin
            f_cost <= g_cost + h_cost;
            if (add_node) begin
                open_list_count <= open_list_count + 1;
            end
            if (move_node) begin
                closed_list_count <= closed_list_count + 1;
                open_list_count <= open_list_count - 1;
            end
        end
    end
endmodule