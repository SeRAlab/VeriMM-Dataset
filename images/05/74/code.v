module bfs #(parameter N = 4) (  
    input clk,  
    input reset,  
    input [N*N-1:0] adjacency_matrix, // Flattened 2D matrix  
    input [1:0] start_node,  
    input start,  
    output reg [N-1:0] visited_nodes,  
    output reg done  
);  
    reg [N-1:0] queue;  
    reg [N-1:0] visited;  
    reg [2:0] state;  
    reg [2:0] next_state;  
    integer i;  
    
    parameter IDLE = 3'b000, ENQUEUE = 3'b001, DEQUEUE = 3'b010, VISIT = 3'b011, FINISH = 3'b100;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            visited <= 0;  
            queue <= 0;  
            visited_nodes <= 0;  
            done <= 0;  
        end else begin  
            state <= next_state;  
        end  
    end  
    
    always @(*) begin  
        case (state)  
            IDLE: begin  
                if (start) begin  
                    next_state = ENQUEUE;  
                end else begin  
                    next_state = IDLE;  
                end  
            end  
            ENQUEUE: begin  
                queue[start_node] = 1;  
                next_state = DEQUEUE;  
            end  
            DEQUEUE: begin  
                for (i = 0; i < N; i = i + 1) begin  
                    if (queue[i] && !visited[i]) begin  
                        visited[i] = 1;  
                        visited_nodes = visited_nodes | (1 << i);  
                        next_state = VISIT;  
                    end  
                end  
                if (next_state != DEQUEUE) begin  
                    queue[i] = 0;  
                end  
            end  
            VISIT: begin  
                for (i = 0; i < N; i = i + 1) begin  
                    if (adjacency_matrix[start_node*N + i] && !visited[i]) begin  
                        queue[i] = 1;  
                    end  
                end  
                next_state = FINISH;  
            end  
            FINISH: begin  
                done = 1;  
                next_state = IDLE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule