module DFS_BinaryTree #(parameter N = 15) (  
    input clk,  
    input [3:0] index,  
    input [N-1:0] tree,  
    output reg [3:0] visited_node,  
    output reg done  
);  
    reg [3:0] stack [0:N-1];  
    reg [3:0] top;  
    reg [3:0] current;  
    integer i;  

    initial begin  
        top = 0;  
        done = 0;  
    end  

    always @(posedge clk) begin  
        if (top == 0 && !done) begin  
            current = index;  
            visited_node = tree[current];  
            stack[top] = current;  
            top = top + 1;  
        end else if (top > 0) begin  
            current = stack[top - 1];  
            top = top - 1;  
            if (2 * current + 1 < N && tree[2 * current + 1] != 0) begin  
                visited_node = tree[2 * current + 1];  
                stack[top] = 2 * current + 1;  
                top = top + 1;  
            end else if (2 * current + 2 < N && tree[2 * current + 2] != 0) begin  
                visited_node = tree[2 * current + 2];  
                stack[top] = 2 * current + 2;  
                top = top + 1;  
            end else begin  
                done = 1;  
            end  
        end  
    end  
endmodule