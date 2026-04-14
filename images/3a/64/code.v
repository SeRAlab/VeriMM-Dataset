module dfs_search(
    input wire clk,
    input wire reset,
    input wire [7:0] target,
    input wire [7:0] node_value,
    input wire node_valid,
    output reg found
);
    reg [7:0] stack [0:15]; // stack for DFS search, max 16 nodes
    reg [3:0] sp; // stack pointer
    reg search_done;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;
            found <= 0;
            search_done <= 0;
        end else if (node_valid) begin
            // Push node_value onto the stack
            stack[sp] <= node_value;
            sp <= sp + 1;
        end else if (sp > 0) begin
            // Pop from the stack
            sp <= sp - 1;
            if (stack[sp] == target) begin
                found <= 1;
                search_done <= 1;
            end
            // Continue DFS by checking left and right children if not found
        end else if (search_done) begin
            // Do nothing, search is done
        end
    end
endmodule