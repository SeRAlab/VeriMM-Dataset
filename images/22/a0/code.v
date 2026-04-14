module dfs_traversal(  
    input clk,  
    input reset,  
    input [7:0] root,  
    output reg [7:0] node_value,  
    output reg done  
);  
    // State encoding  
    reg [1:0] state;  
    parameter IDLE = 2'b00, TRAVERSING = 2'b01, DONE = 2'b10;  
    reg [15:0] stack [0:15]; // Stack for DFS  
    reg [3:0] sp; // Stack pointer  
    reg [7:0] current_node;  
  
    // Initialize  
    initial begin  
        sp = 0;  
        done = 0;  
        state = IDLE;  
    end  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sp = 0;  
            done = 0;  
            state = IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (root != 8'h00) begin  
                        stack[sp] = root; // Push the root onto stack  
                        sp = sp + 1;  
                        state = TRAVERSING;  
                    end else begin  
                        done = 1;  
                    end  
                end  
                TRAVERSING: begin  
                    if (sp > 0) begin  
                        sp = sp - 1;  
                        current_node = stack[sp]; // Pop from stack  
                        node_value = current_node;  
                        // Push right and left children if they exist (dummy values here)  
                        if (current_node + 1 < 8'hFF) begin  
                            stack[sp] = current_node + 1; // Right child  
                            sp = sp + 1;  
                        end  
                        if (current_node + 2 < 8'hFF) begin  
                            stack[sp] = current_node + 2; // Left child  
                            sp = sp + 1;  
                        end  
                    end else begin  
                        done = 1;  
                        state = DONE;  
                    end  
                end  
                DONE: begin  
                    // Stay in done state  
                end  
            endcase  
        end  
    end  
endmodule