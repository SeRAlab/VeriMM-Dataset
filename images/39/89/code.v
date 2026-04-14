module DFS_BinaryTree (
    input clk,
    input rst,
    input [3:0] root_value,
    output reg [3:0] visited_value,
    output reg done
);
    reg [3:0] stack [0:15]; // Simple stack to hold node values
    reg [3:0] top; // Stack pointer
    reg [3:0] current_node;
    reg state; // 0: Idle, 1: Traversing

    // Initial conditions
    initial begin
        top = 0;
        done = 0;
        state = 0;
        visited_value = 0;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            top <= 0;
            current_node <= root_value;
            visited_value <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (top > 0) begin
                        current_node <= stack[top - 1]; // Get the top node
                        visited_value <= current_node; // Visit the node
                        top <= top - 1; // Pop the stack
                        state <= 1; // Move to Traversing state
                    end else begin
                        done <= 1; // Traversal is done
                    end
                end
                1: begin // Traversing state
                    // Push children to stack (dummy logic for binary tree)
                    stack[top] <= current_node + 1; // Right child
                    top <= top + 1;
                    stack[top] <= current_node - 1; // Left child
                    top <= top + 1;
                    state <= 0; // Go back to Idle state
                end
            endcase
        end
    end
endmodule