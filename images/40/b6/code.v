module astar_search(
    input clk,
    input rst,
    input [1:0] current_node,
    input [1:0] goal_node,
    input [3:0] cost_to_current,
    input [3:0] heuristic_estimate,
    output reg [1:0] next_node
);
    reg [3:0] f_score [3:0]; // f(n) = g(n) + h(n)
    reg [1:0] path [3:0];     // Store the path for nodes

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            next_node <= 2'b00;
            f_score[0] <= 4'd15; // High initial values
            f_score[1] <= 4'd15;
            f_score[2] <= 4'd15;
            f_score[3] <= 4'd15;
        end else begin
            f_score[current_node] <= cost_to_current + heuristic_estimate;
            // Simplified selection logic
            if (f_score[current_node] < f_score[next_node]) begin
                next_node <= current_node;
            end
            
            // Update path for next node based on some criteria
            // Here we could just cycle between nodes for simplicity
            if (next_node < 2'b11) 
                next_node <= next_node + 1;
            else 
                next_node <= 2'b00; // Wrap around to start
        end
    end
endmodule