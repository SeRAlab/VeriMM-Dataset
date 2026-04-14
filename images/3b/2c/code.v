module dfs_traversal(
    input clk,
    input rst,
    input [7:0] node_val,
    input node_valid,
    input start,
    output reg [7:0] output_val,
    output reg done
);
    reg [7:0] stack[0:15]; // Stack for DFS, max depth 16
    reg [3:0] sp; // Stack pointer
    reg [3:0] current_state;
    parameter IDLE = 0, PUSH = 1, POP = 2, OUTPUT = 3, COMPLETE = 4;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            sp <= 0;
            current_state <= IDLE;
            done <= 0;
            output_val <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) begin
                        current_state <= PUSH;
                    end
                end
                PUSH: begin
                    if (node_valid && sp < 16) begin
                        stack[sp] <= node_val;
                        sp <= sp + 1;
                    end
                    if (sp > 0) begin
                        current_state <= POP;
                    end else begin
                        current_state <= COMPLETE;
                    end
                end
                POP: begin
                    sp <= sp - 1;
                    output_val <= stack[sp];
                    current_state <= OUTPUT;
                end
                OUTPUT: begin
                    if (sp > 0) begin
                        current_state <= POP;
                    end else begin
                        current_state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    done <= 1;
                end
            endcase
        end
    end
endmodule