module bfs_traversal(  
    input clk,  
    input reset,  
    input [24:0] adj_matrix, // 5x5 adjacency matrix  
    input [2:0] start_node,  // starting node  
    output reg [4:0] visited_nodes // 5-bit output indicating visited nodes  
);  
    reg [4:0] queue; // queue for BFS  
    reg [4:0] next_queue;  
    reg [4:0] visited;  
    integer i;  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            visited <= 5'b0;  
            queue <= 5'b0;  
            visited_nodes <= 5'b0;  
        end else begin  
            if (queue == 5'b0) begin  
                queue <= 5'b1 << start_node; // enqueue starting node  
            end else begin  
                for (i = 0; i < 5; i = i + 1) begin  
                    if (queue[i]) begin  
                        visited_nodes <= visited_nodes | (5'b1 << i);  
                        visited[i] <= 1'b1;  
                        next_queue = next_queue | (adj_matrix[(5*i)+:5] & ~visited);  
                    end  
                end  
                queue <= next_queue;  
                next_queue <= 5'b0;  
            end  
        end  
    end  
endmodule