module bfs_traversal(
    input clk,
    input rst,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
);
    reg [7:0] queue [0:15]; // Simple static queue for BFS
    reg [3:0] head, tail; // Pointers for the queue
    reg [3:0] state; // State variable for FSM
    parameter IDLE = 0, ENQUEUE = 1, DEQUEUE = 2, OUTPUT = 3;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            state <= IDLE;
            done <= 0;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        queue[tail] <= data_in; // Enqueue the starting node
                        tail <= tail + 1;
                        state <= DEQUEUE; // Move to Dequeue state
                    end
                end
                
                DEQUEUE: begin
                    if (head < tail) begin
                        data_out <= queue[head]; // Output current node
                        head <= head + 1; // Move head pointer
                        state <= OUTPUT; // Move to Output state
                    end else begin
                        done <= 1; // Finished traversal
                        state <= IDLE; // Go back to IDLE
                    end
                end
                
                OUTPUT: begin
                    // Wait for the next clock cycle to dequeue again
                    state <= DEQUEUE;
                end
                
            endcase
        end
    end
endmodule