module bfs #(parameter N = 5) (  
    input clk,  
    input reset,  
    input [N-1:0] start_node,  
    input [N*N-1:0] adj_matrix,  
    output reg [N-1:0] visited_nodes  
);  
    reg [N-1:0] queue;  
    reg [N-1:0] visited;  
    integer i, current_node;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            visited_nodes <= 0;  
            queue <= 0;  
            visited <= 0;  
        end else begin  
            if (queue == 0) begin  
                // Start BFS from the input start_node  
                queue <= start_node;  
                visited <= start_node;  
                visited_nodes <= visited;  
            end else begin  
                current_node = queue[0];  
                queue = queue >> 1; // Dequeue the front node  
                
                for (i = 0; i < N; i = i + 1) begin  
                    if (adj_matrix[current_node*N + i] && !visited[i]) begin  
                        queue = queue | (1 << i);  
                        visited = visited | (1 << i);  
                        visited_nodes <= visited;  
                    end  
                end  
            end  
        end  
    end  
endmodule