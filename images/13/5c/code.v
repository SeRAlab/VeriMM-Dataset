module bfs_tree_traversal(  
    input clk,  
    input rst,  
    input [15:0] tree_nodes,  
    output reg [3:0] bfs_output,  
    output reg done  
);  
    reg [3:0] queue [0:15];  
    reg [3:0] front, rear;  
    reg [3:0] count;  
    reg [3:0] index;  
    reg state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            front <= 0;  
            rear <= 0;  
            count <= 0;  
            index <= 0;  
            done <= 0;  
            bfs_output <= 0;  
            state <= 0;  
        end  
        else begin  
            if (!done) begin  
                if (state == 0) begin  
                    if (count < 16 && tree_nodes[count]) begin  
                        queue[rear] <= count;  
                        rear <= rear + 1;  
                        count <= count + 1;  
                    end  
                    else begin  
                        state <= 1;  
                    end  
                end  
                else begin  
                    if (front < rear) begin  
                        bfs_output <= queue[front];  
                        front <= front + 1;  
                    end  
                    else begin  
                        done <= 1;  
                    end  
                end  
            end  
        end  
    end  
endmodule