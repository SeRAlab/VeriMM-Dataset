module dfs_traversal(input clk,  
                     input [3:0] root,  
                     output reg [15:0] visited_nodes);  

    reg [3:0] stack [0:15];  
    reg [3:0] top;  
    reg [3:0] current;  
    reg [3:0] left, right;  
    reg [3:0] i;  
    reg [3:0] node;  

    initial begin  
        top = 0;  
        visited_nodes = 0;  
        stack[top] = root;  
    end  

    always @(posedge clk) begin  
        if (top > 0) begin  
            node = stack[top];  
            top = top - 1;  
            visited_nodes = visited_nodes | (1 << node);  

            left = node * 2;  
            right = node * 2 + 1;  

            if (right < 16) begin  
                stack[top + 1] = right;  
                top = top + 1;  
            end  

            if (left < 16) begin  
                stack[top + 1] = left;  
                top = top + 1;  
            end  
        end  
    end  
endmodule