module bfs_tree (
    input clk,
    input rst,
    input start,
    input [4:0] root, // Assume 5-bit input to represent the node values
    output reg [4:0] output_value,
    output reg done
);
    reg [4:0] queue [0:15]; // Queue for BFS, max size 16
    reg [3:0] front, rear; // Pointers for the queue
    reg [3:0] state; // State variable
    reg [4:0] current_node; // Current node being processed
    reg processing; // Flag to indicate processing state

    localparam IDLE = 0, ENQUEUE = 1, DEQUEUE = 2, OUTPUT = 3, COMPLETE = 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            front <= 0;
            rear <= 0;
            state <= IDLE;
            done <= 0;
            output_value <= 0;
            processing <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        queue[rear] <= root; // Enqueue root node
                        rear <= rear + 1;
                        state <= ENQUEUE;
                        processing <= 1;
                    end
                end
                ENQUEUE: begin
                    if (front < rear) begin
                        current_node = queue[front]; // Dequeue node
                        front <= front + 1;
                        output_value <= current_node; // Output current node value
                        state <= OUTPUT;
                    end else if (processing) begin
                        done <= 1; // BFS complete
                        state <= COMPLETE;
                    end
                end
                OUTPUT: begin
                    // Here you can enqueue the left and right children if needed
                    // For simplicity, we assume 0 children. If there were children, enqueue them here.
                    state <= ENQUEUE;
                end
                COMPLETE: begin
                    done <= 1; // Stay in complete state
                end
            endcase
        end
    end
endmodule