module dfs_tree(input clk,  
                input [3:0] current_node,  
                output reg [3:0] next_node);  
                
    reg [3:0] stack [0:15];  
    reg [3:0] top;  
    reg [3:0] left_child, right_child;  

    initial begin  
        top = 0;  
    end  

    always @(posedge clk) begin  
        if (top == 0) begin  
            next_node = current_node;  
            stack[top] = current_node;  
            top = top + 1;  
        end else begin  
            top = top - 1;  
            next_node = stack[top];  
            left_child = next_node * 2 + 1;  
            right_child = next_node * 2 + 2;  
            if (right_child < 16) begin  
                stack[top] = right_child;  
                top = top + 1;  
            end  
            if (left_child < 16) begin  
                stack[top] = left_child;  
                top = top + 1;  
            end  
        end  
    end  
endmodule