module bfs_tree(input clk,  
                input reset,  
                input start,  
                output reg [7:0] output_data,  
                output reg done);  

    reg [3:0] current_level;  
    reg [15:0] queue [0:15]; // Queue to hold node indices  
    reg [3:0] head, tail;  
    reg [7:0] tree [0:15]; // Fixed size binary tree  

    initial begin  
        // Sample binary tree initialization  
        tree[0] = 8'd1;  
        tree[1] = 8'd2;  
        tree[2] = 8'd3;  
        tree[3] = 8'd4;  
        tree[4] = 8'd5;  
        tree[5] = 8'd6;  
        tree[6] = 8'd7;  
        tree[7] = 8'd8;  
        tree[8] = 8'd9;  
        tree[9] = 8'd10;  
        tree[10] = 8'd11;  
        tree[11] = 8'd12;  
        tree[12] = 8'd13;  
        tree[13] = 8'd14;  
        tree[14] = 8'd15;  
        tree[15] = 8'd16;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            head <= 0;  
            tail <= 0;  
            current_level <= 0;  
            done <= 0;  
            output_data <= 8'd0;  
        end else if (start) begin  
            // Enqueue the root node  
            queue[tail] <= 0;  
            tail <= tail + 1;  
            done <= 0;  
        end else if (head < tail) begin  
            // Dequeue node  
            output_data <= tree[queue[head]];  
            head <= head + 1;  
            // Enqueue the left child  
            if (queue[head - 1] * 2 + 1 < 16) begin  
                queue[tail] <= queue[head - 1] * 2 + 1;  
                tail <= tail + 1;  
            end  
            // Enqueue the right child  
            if (queue[head - 1] * 2 + 2 < 16) begin  
                queue[tail] <= queue[head - 1] * 2 + 2;  
                tail <= tail + 1;  
            end  
        end else begin  
            done <= 1; // BFS is done  
        end  
    end  
endmodule