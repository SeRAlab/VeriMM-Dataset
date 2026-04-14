module bfs_tree (
    input clk,
    input reset,
    input [7:0] node_value,
    input valid,
    output reg [7:0] bfs_output,
    output reg done
);
    reg [7:0] queue [0:15];  // queue for BFS
    reg [3:0] front, rear;    // pointers for queue
    reg [3:0] state;          // state variable
    reg [3:0] count;          // count of nodes visited

    initial begin
        front = 0;
        rear = 0;
        count = 0;
        done = 0;
        state = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            front <= 0;
            rear <= 0;
            count <= 0;
            bfs_output <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin
                    if (valid) begin
                        queue[rear] <= node_value; // enqueue node
                        rear <= rear + 1;
                        count <= count + 1;
                        state <= 1; // move to next state
                    end
                end
                1: begin
                    if (count > 0) begin
                        bfs_output <= queue[front]; // output node
                        front <= front + 1;
                        count <= count - 1;
                    end else begin
                        done <= 1; // BFS completed
                        state <= 0; // reset state
                    end
                end
            endcase
        end
    end
endmodule