module dfs_tree #(parameter SIZE = 16) (  
    input clk,  
    input rst,  
    input enable,  
    input [3:0] root_node,  
    output reg [3:0] visited_node,  
    output reg done  
);  
    reg [3:0] stack [0:SIZE-1];  
    reg [3:0] current;  
    reg [3:0] top;  
    reg [3:0] next;  
    reg [3:0] left_child, right_child;  
    integer i;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            done <= 0;  
            visited_node <= 0;  
            top <= 0;  
            current <= root_node;  
            for (i = 0; i < SIZE; i = i + 1)  
                stack[i] <= 0;  
        end else if (enable) begin  
            if (top > 0) begin  
                top = top - 1;  
                current = stack[top];  
                visited_node = current;  
                // Push left and right children to the stack  
                left_child = current * 2;  
                right_child = current * 2 + 1;  
                if (right_child < SIZE) begin  
                    stack[top] = right_child;  
                    top = top + 1;  
                end  
                if (left_child < SIZE) begin  
                    stack[top] = left_child;  
                    top = top + 1;  
                end  
            end else begin  
                done <= 1;  
            end  
        end  
    end  
endmodule