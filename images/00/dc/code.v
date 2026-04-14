module dfs_stack (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [3:0] node_in,
    output reg [3:0] current_node,
    output reg done
);
    reg [3:0] stack [0:15]; // Stack to hold nodes
    reg [3:0] sp; // Stack Pointer
    reg [3:0] state; // State variable
    parameter IDLE = 0, PROCESS = 1, COMPLETE = 2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sp <= 0;
            current_node <= 4'b0000;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        stack[sp] <= node_in; // Push node onto stack
                        sp <= sp + 1;
                        state <= PROCESS;
                    end
                end
                PROCESS: begin
                    if (sp > 0) begin
                        sp <= sp - 1;
                        current_node <= stack[sp]; // Pop node from stack
                    end else begin
                        state <= COMPLETE;
                    end
                end
                COMPLETE: begin
                    done <= 1; // Indicate completion
                    state <= IDLE; // Reset state
                end
            endcase
        end
    end
endmodule