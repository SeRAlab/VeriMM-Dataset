module dfs_tree #(parameter N = 8) (  
    input clk,  
    input reset,  
    input [N-1:0] current_node,  
    input [N-1:0] next_node,  
    input push,  
    input pop,  
    output reg [N-1:0] visited_nodes  
);  
    reg [N-1:0] stack [0:N-1];  
    reg [3:0] sp; // stack pointer  

    initial begin  
        sp = 0;  
        visited_nodes = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp <= 0;  
            visited_nodes <= 0;  
        end else begin  
            if (push) begin  
                stack[sp] <= next_node;  
                visited_nodes[next_node] <= 1;  
                sp <= sp + 1;  
            end  
            if (pop && sp > 0) begin  
                sp <= sp - 1;  
                visited_nodes[stack[sp]] <= 0;  
            end  
        end  
    end  
endmodule