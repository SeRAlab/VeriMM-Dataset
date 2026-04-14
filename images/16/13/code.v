module bfs (
    input clk,
    input rst,
    input [3:0] start_node,
    input [15:0] adj_matrix,
    output reg [3:0] visited_nodes,
    output reg done
);
    reg [3:0] queue [0:3];
    reg [1:0] head, tail;
    reg [15:0] visited;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            visited <= 0;
            visited_nodes <= 0;
            done <= 0;
            queue[0] <= start_node;
        end else if (!done) begin
            if (head < tail) begin
                visited_nodes <= queue[head];
                visited[queue[head]] <= 1;
                for (i = 0; i < 4; i = i + 1) begin
                    if (adj_matrix[queue[head]*4 + i] && !visited[i]) begin
                        queue[tail] <= i;
                        tail <= tail + 1;
                    end
                end
                head <= head + 1;
            end else begin
                done <= 1;
            end
        end
    end
endmodule