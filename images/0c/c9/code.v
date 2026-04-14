module dfs_tree(input clk,  
                input reset,  
                input [7:0] node_value,  
                input push,  
                input pop,  
                output reg [7:0] visited_node,  
                output reg valid);  
  
    reg [7:0] stack [0:15];  
    reg [3:0] sp;  // stack pointer  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp <= 0;  
            valid <= 0;  
        end else begin  
            if (push) begin  
                stack[sp] <= node_value;  
                sp <= sp + 1;  
            end  
            if (pop && sp > 0) begin  
                sp <= sp - 1;  
                visited_node <= stack[sp];  
                valid <= 1;  
            end else begin  
                valid <= 0;  
            end  
        end  
    end  
endmodule