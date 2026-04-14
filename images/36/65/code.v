module dfs_tree (
    input clk,
    input rst,
    input start,
    input [3:0] node_value,
    output reg [3:0] current_value
);
    reg [1:0] state; // State: 00 - idle, 01 - visiting, 10 - done
    parameter IDLE = 2'b00, VISITING = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_value <= 4'b0000;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= VISITING;
                    end
                end
                VISITING: begin
                    current_value <= node_value; // Update current value
                    state <= DONE; // Move to done state after visiting
                end
                DONE: begin
                    state <= IDLE; // Reset to idle after completing visit
                end
            endcase
        end
    end
endmodule