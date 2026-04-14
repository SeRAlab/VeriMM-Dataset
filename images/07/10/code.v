module AStarNextNode (
    input [4:0] current_node,
    input [4:0] heuristic,
    input [4:0] goal_node,
    output reg [4:0] next_node
);
    reg [4:0] cost [0:31]; // Assuming a cost array for 32 nodes
    integer i;

    always @(*) begin
        // Initialize next_node to a high value
        next_node = 5'b11111; 
        
        // Calculate the cost to each node from the current node
        for (i = 0; i < 32; i = i + 1) begin
            if (cost[current_node] + heuristic[i] < cost[next_node]) begin
                next_node = i;
            end
        end
    end
endmodule