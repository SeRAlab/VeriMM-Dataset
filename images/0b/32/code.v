module DFS (
    input wire clk,
    input wire reset,
    input wire start,
    output reg [3:0] visited,
    output reg [3:0] path
);
    reg [3:0] stack; // Stack to hold the nodes
    reg [1:0] state; // State variable

    parameter IDLE = 2'b00, VISIT = 2'b01, BACKTRACK = 2'b10;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            visited <= 0;
            path <= 0;
            stack <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        // Start DFS
                        stack <= 4'b0001; // Begin with root node
                        state <= VISIT;
                    end
                end
                VISIT: begin
                    if (stack != 0) begin
                        // Pop the top node from the stack
                        visited <= stack;
                        path <= path | stack; // Mark as visited
                        stack <= stack >> 1; // Move to the next node (left child)
                    end else begin
                        state <= BACKTRACK; // No more nodes to visit, backtrack
                    end
                end
                BACKTRACK: begin
                    // Backtrack by popping nodes until stack is empty
                    if (stack == 0) begin
                        state <= IDLE; // Finished DFS
                    end else begin
                        visited <= stack;
                        path <= path | stack;
                        stack <= stack >> 1; // Move to right child
                    end
                end
            endcase
        end
    end
endmodule