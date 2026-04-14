module dfs_controller(
    input clk,
    input rst,
    input start,
    input [15:0] tree,
    output reg [15:0] visited,
    output reg done
);
    reg [3:0] state;
    reg [3:0] index_stack[0:15]; // Stack for storing indices
    reg [3:0] stack_ptr;

    parameter IDLE = 4'b0000,
              PUSH = 4'b0001,
              POP = 4'b0010,
              TRAVERSE = 4'b0011,
              DONE = 4'b0100;

    initial begin
        visited = 16'b0;
        done = 0;
        stack_ptr = 0;
        state = IDLE;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            visited <= 16'b0;
            done <= 0;
            stack_ptr <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        index_stack[stack_ptr] <= 0; // Start from root
                        stack_ptr <= stack_ptr + 1;
                        state <= TRAVERSE;
                    end
                end
                TRAVERSE: begin
                    if (stack_ptr > 0) begin
                        stack_ptr <= stack_ptr - 1;
                        visited[index_stack[stack_ptr]] <= 1'b1; // Mark as visited
                        // Push right child
                        if (2 * index_stack[stack_ptr] + 2 < 16 && tree[2 * index_stack[stack_ptr] + 2]) begin
                            index_stack[stack_ptr] <= 2 * index_stack[stack_ptr] + 2;
                            stack_ptr <= stack_ptr + 1;
                        end
                        // Push left child
                        if (2 * index_stack[stack_ptr] + 1 < 16 && tree[2 * index_stack[stack_ptr] + 1]) begin
                            index_stack[stack_ptr] <= 2 * index_stack[stack_ptr] + 1;
                            stack_ptr <= stack_ptr + 1;
                        end
                    end else begin
                        done <= 1; // DFS complete
                        state <= DONE;
                    end
                end
                DONE: begin
                    // Do nothing, stay in DONE state
                end
            endcase
        end
    end
endmodule