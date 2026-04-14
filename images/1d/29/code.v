module bfs_traversal (  
    input wire clk,  
    input wire [15:0] adj_matrix, // 4x4 adjacency matrix  
    input wire [1:0] start_node,  
    output reg [15:0] traverse_order  
);  
    reg [3:0] visited;  
    reg [7:0] queue;  
    reg [3:0] front;  
    reg [3:0] rear;  
    integer i;  

    always @(posedge clk) begin  
        if (visited == 0) begin  
            visited[start_node] <= 1;  
            queue[rear] <= start_node;  
            rear <= rear + 1;  
        end else if (front < rear) begin  
            traverse_order <= {traverse_order[11:0], queue[front]};  
            front <= front + 1;  
            for (i = 0; i < 4; i = i + 1) begin  
                if (adj_matrix[front * 4 + i] && !visited[i]) begin  
                    visited[i] <= 1;  
                    queue[rear] <= i;  
                    rear <= rear + 1;  
                end  
            end  
        end  
    end  
endmodule