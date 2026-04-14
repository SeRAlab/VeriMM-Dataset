module DFS_BinaryTree (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] node_value,
    output reg [7:0] dfs_output,
    output reg done
);
    reg [3:0] state;
    reg [15:0] stack [0:15]; // Stack for DFS
    reg [3:0] sp; // Stack pointer

    parameter IDLE = 0, PUSH = 1, POP = 2, OUTPUT = 3;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            sp <= 0;
            done <= 0;
            dfs_output <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        stack[sp] <= node_value; // Push the root node
                        sp <= sp + 1;
                        state <= PUSH;
                    end
                end
                PUSH: begin
                    if (sp > 0) begin
                        dfs_output <= stack[sp - 1]; // Output the top of the stack
                        sp <= sp - 1; // Pop the stack
                        state <= OUTPUT;
                    end else begin
                        done <= 1; // No more nodes to process
                        state <= IDLE; // Go back to IDLE
                    end
                end
                OUTPUT: begin
                    state <= PUSH; // Go back to pushing next node
                end
            endcase
        end
    end
endmodule