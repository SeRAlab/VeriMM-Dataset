module bfs_fsm (input clk, input rst, input [3:0] start_node, output reg [3:0] visited_node, output reg done);  
    reg [3:0] state;  
    reg [3:0] queue [0:15];  
    integer head, tail;  
    initial begin  
        state = 0;  
        head = 0;  
        tail = 0;  
        done = 0;  
    end  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            visited_node <= 0;  
            done <= 0;  
            state <= 0;  
            head <= 0;  
            tail <= 0;  
        end else begin  
            case (state)  
                0: begin  
                    queue[tail] <= start_node;  
                    tail <= tail + 1;  
                    visited_node <= queue[head];  
                    state <= 1;  
                end  
                1: begin  
                    if (head < tail) begin  
                        head <= head + 1;  
                        visited_node <= queue[head];  
                    end else begin  
                        done <= 1;  
                        state <= 2;  
                    end  
                end  
                2: begin  
                    // Finished processing  
                end  
            endcase  
        end  
    end  
endmodule