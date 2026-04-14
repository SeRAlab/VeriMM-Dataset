module bfs #(parameter N = 4) (  
    input clk,  
    input rst,  
    input [N*N-1:0] adj_matrix,  
    input [N-1:0] start_node,  
    output reg [N-1:0] visited_nodes  
);  
    reg [N-1:0] queue [0:N-1];  
    reg [N-1:0] front, rear;  
    reg [N-1:0] current_node;  
    reg [N-1:0] next_node;  
    reg [N-1:0] visited;  

    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            visited = 0;  
            front = 0;  
            rear = 0;  
            visited_nodes = 0;  
            queue[rear] = start_node;  
            rear = rear + 1;  
        end else if (front < rear) begin  
            current_node = queue[front];  
            visited[current_node] = 1;  
            visited_nodes = visited_nodes | (1 << current_node);  
            front = front + 1;  

            for (i = 0; i < N; i = i + 1) begin  
                if (adj_matrix[current_node * N + i] && !visited[i]) begin  
                    queue[rear] = i;  
                    rear = rear + 1;  
                end  
            end  
        end  
    end  
endmodule